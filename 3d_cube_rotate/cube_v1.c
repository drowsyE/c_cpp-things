#include <math.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <ApplicationServices/ApplicationServices.h>
#include <signal.h>

#define CUBE_SIZE 5.0
#define D 15.0
#define FOCAL_LENGTH 10.0
#define INTERPOLATION_POINTS 8

typedef struct vec2 {
    int x;
    int y;
} vec2;

typedef struct face {
    int indices[4];
    double avg_z;
} face;

double vertex[8*3] = {
    // {x, y, z}
    CUBE_SIZE, CUBE_SIZE, CUBE_SIZE,
    -CUBE_SIZE, CUBE_SIZE, CUBE_SIZE,
    -CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE,
    CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE,
    CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE,
    -CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE,
    -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,
    CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,
};

double vertex_rotated[8*3] = {0.0};

vec2 *buffer = NULL;
vec2 *buffer_interpolated = NULL;

int edges[12][2] = {
    {0,1}, {1,2}, {2,3}, {3,0}, // 윗면
    {4,5}, {5,6}, {6,7}, {7,4}, // 아랫면
    {0,4}, {1,5}, {2,6}, {3,7}  // 기둥
};

face cube_faces[6] = {
    {{0, 1, 2, 3}, 0}, // 앞면
    {{4, 5, 6, 7}, 0}, // 뒷면
    {{0, 1, 5, 4}, 0}, // 윗면
    {{2, 3, 7, 6}, 0}, // 아랫면
    {{0, 3, 7, 4}, 0}, // 우측면
    {{1, 2, 6, 5}, 0}  // 좌측면
};

void swap_buffer_ptr(vec2 (**p1)[8], vec2 (**p2)[8]) {
    vec2 (*tmp)[8] = *p1;
    *p1 = *p2;
    *p2 = tmp;
}

void get_screen_size(double *width, double *height) {
    CGDirectDisplayID displayID = CGMainDisplayID();
    
    CGRect bounds = CGDisplayBounds(displayID);
    
    *width = bounds.size.width;
    *height = bounds.size.height;
}

void get_terminal_size(int *cols, int *rows) {
    struct winsize w;
    // STDOUT_FILENO(표준 출력)의 창 크기 정보를 가져옴
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    
    *cols = w.ws_col;
    *rows = w.ws_row;
}

void gotoxy(int x, int y) {
    printf("\033[%d;%dH", y, x);
}

void matmul_mm(double* A, double* B, double* C, int M, int N, int K) {
    memset(C, 0.0, sizeof(double)*M*K);

    for (int i=0; i<M; i++) {
        for (int k=0; k<N; k++) {
            double e = A[i*N + k];

            for (int j=0; j<K; j++) {
                C[i*K + j] += e * B[k*K + j];
            }
        }
    }
}

// void pingpong_matmul(double* buffer1, double* buffer2, double* X, int M, int N, int K) {
//     static int flag = 0;
//     // if flag = 0 : src -> buffer 1, dst -> buffer2
//     // if flag = 1 : src -> buffer 2, dst -> buffer1

//     switch (flag) {
//         case 0:
//             matmul_mm(buffer1, X, buffer2, M, N, K);
//             break;
//         case 1:
//             matmul_mm(buffer2, X, buffer1, M, N, K);
//             break;
//     }
//     flag = !flag;
// }

void getAngle(double rel_x, double rel_y, double *alpha, double *beta) {
    // 화면상의 픽셀 이동거리를 각도로 변환 (숫자가 클수록 느리게 회전)
    double sensitivity = 400.0; 
    
    // 좌우 이동(rel_x) -> Y축 회전(beta)
    *beta = -rel_x / sensitivity;
    
    // 상하 이동(rel_y) -> X축 회전(alpha)
    // 마우스를 내릴 때(rel_y > 0) 큐브가 뒤로 넘어가야 하므로 부호 주의
    *alpha = -rel_y / sensitivity;
}

// follows row-convention
void get_rotation_matrix(double alpha, double beta, double R[9]) {
    double ca = cos(alpha), sa = sin(alpha);
    double cb = cos(beta),  sb = sin(beta);

    R[0] = cb;            R[1] = 0;             R[2] = -sb;
    R[3] = -sa * sb;      R[4] = ca;            R[5] = -sa * cb;
    R[6] = ca * sb;       R[7] = sa;            R[8] = ca * cb;
}

// interpolate after rotation + projection
void interpolate(double v1[3], double v2[3], double v3[3], double alpha) {
    v3[0] = v1[0] * alpha + v2[0] * (1-alpha);
    v3[1] = v1[1] * alpha + v2[1] * (1-alpha);
    v3[2] = v1[2] * alpha + v2[2] * (1-alpha);
}

void fill_triangle(vec2 p1, vec2 p2, vec2 p3, char ch) {
    // --- y좌표 기준 정렬 (p1이 제일 위, p3가 제일 아래) ---
    if (p1.y > p2.y) { vec2 tmp = p1; p1 = p2; p2 = tmp; }
    if (p1.y > p3.y) { vec2 tmp = p1; p1 = p3; p3 = tmp; }
    if (p2.y > p3.y) { vec2 tmp = p2; p2 = p3; p3 = tmp; }

    if (p1.y == p3.y) return; // 삼각형이 아님 (수평선)

    for (int y = p1.y; y <= p3.y; y++) {
        // 화면 범위를 벗어나는 출력 방지
        if (y < 1) continue; 

        float t1 = (float)(y - p1.y) / (p3.y - p1.y);
        int start_x = p1.x + t1 * (p3.x - p1.x);

        int end_x;
        if (y < p2.y) {
            if (p2.y == p1.y) end_x = p2.x;
            else {
                float t2 = (float)(y - p1.y) / (p2.y - p1.y);
                end_x = p1.x + t2 * (p2.x - p1.x);
            }
        } else {
            if (p3.y == p2.y) end_x = p2.x;
            else {
                float t2 = (float)(y - p2.y) / (p3.y - p2.y);
                end_x = p2.x + t2 * (p3.x - p2.x);
            }
        }

        if (start_x > end_x) { int tmp = start_x; start_x = end_x; end_x = tmp; }
        for (int x = start_x; x <= end_x; x++) {
            gotoxy(x, y);
            putchar(ch);
        }
    }
}

void handle_sigint(int sig) {
    printf("\033[?25h\n"); // 커서 보이기
    free(buffer);
    free(buffer_interpolated);
    exit(0);
}

int compare_faces(const void* a, const void* b) {
    face* f1 = (face*) a;
    face* f2 = (face*) b;
    return (f1->avg_z < f2->avg_z) - (f1->avg_z > f2->avg_z); // 내림차순 정렬
}

char get_face_char(double avg_z) {
    // z값이 작을수록(가까울수록) 인덱스가 낮은 문자를 선택
    // 문자 배열을 밝기/밀도 순으로 배치
    
    const char* shades = "@#*+=-:. "; 
    int num_shades = strlen(shades);

    double min_z = - CUBE_SIZE;
    double max_z = + CUBE_SIZE;
    
    double norm = (avg_z - min_z) / (max_z - min_z);
    
    // 안전장치: 범위를 벗어나지 않게 클램핑
    if (norm < 0) norm = 0;
    if (norm > 0.99) norm = 0.99;

    int index = (int)(norm * num_shades);
    return shades[index];
}

int main() {

    signal(SIGINT, handle_sigint); // control + c가 들어오면 실행

    int terminal_width, terminal_height, center_x, center_y, x_idx, y_idx, z_idx, tx, ty, ix, iy, p1_idx, p2_idx;
    buffer = (vec2*) calloc(8, sizeof(vec2));
    buffer_interpolated = (vec2*) calloc(INTERPOLATION_POINTS * 12, sizeof(vec2));
    double ratio;

    CGRect screenRect = CGDisplayBounds(CGMainDisplayID());
    double screen_mid_x = screenRect.size.width / 2.0;
    double screen_mid_y = screenRect.size.height / 2.0;

    while (1) {

        system("clear");

        get_terminal_size(&terminal_width, &terminal_height);
        center_x = terminal_width/2;
        center_y = terminal_height/2+1;

        // get cursor position
        CGEventRef event = CGEventCreate(NULL);
        CGPoint cursor = CGEventGetLocation(event);
        CFRelease(event);

        double rel_x = cursor.x - screen_mid_x;
        double rel_y = cursor.y - screen_mid_y;

        // get angle via cursor position. assume center of the cube is D
        double alpha, beta;
        getAngle(rel_x, rel_y, &alpha, &beta);

        // get rotation matrix + rotate vertices
        double rotMat[3*3] = {0.0};
        get_rotation_matrix(alpha, beta, rotMat);

        matmul_mm(vertex, rotMat, vertex_rotated, 8, 3, 3);

        // calculate average z coordinate of each face of cube
        double sum_z;
        for (int i=0; i<6; i++) {
            sum_z = 0;
            for (int j=0; j<4; j++) {
                sum_z += vertex_rotated[(cube_faces[i].indices[j])*3 + 2];
            }
            cube_faces[i].avg_z = sum_z/4.0;
        }
        qsort(cube_faces, 6, sizeof(face), compare_faces);

        // projection
        for (int i = 0; i < 8; i++) {
            
            // 이동 및 원근 투영 (수식 적용)
            x_idx = i*3; y_idx = x_idx+1; z_idx = x_idx+2;
            double z_world = vertex_rotated[z_idx] + D;
            double factor = FOCAL_LENGTH / z_world;
            
            tx = (int)(center_x + vertex_rotated[x_idx] * factor * 2.2);
            ty = (int)(center_y + vertex_rotated[y_idx] * factor);
            
            gotoxy(buffer[i].x, buffer[i].y);
            putchar(' ');

            // 사영된 2차원 좌표들을 출력
            // gotoxy(tx,ty);
            // putchar('@');

            buffer[i].x = tx;
            buffer[i].y = ty;
        }

        for (int i = 0; i < 6; i++) {
            // 1. 해당 면의 4개 꼭짓점의 2D 투영 좌표를 가져옴
            vec2 p[4];
            for (int j = 0; j < 4; j++) {
                p[j] = buffer[cube_faces[i].indices[j]];
            }

            char face_shading = get_face_char(cube_faces[i].avg_z);
            // 2. 사각형을 두 개의 삼각형으로 나눠서 채우기
            fill_triangle(p[0], p[1], p[2], face_shading); 
            fill_triangle(p[0], p[2], p[3], face_shading);
        }

        fflush(stdout); // 버퍼 비우기 추가
        usleep(16000);
    }
    
    free(buffer);
    free(buffer_interpolated);
    return 0;
}