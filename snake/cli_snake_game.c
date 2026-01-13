#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

#define FIELD_WIDTH 10
#define FIELD_HEIGHT 10
#define MAX_APPLE_COUNT 10 
#define APPLE_GEN_PROB 0.1

typedef struct pair {
    short x;
    short y;
} Pos;

typedef struct snake {
    int x;
    int y;
    int length;
} Snake;

typedef struct queue {
    int front;
    int rear;
    Pos* arr;
} Queue;

typedef struct apple {
    int x;
    int y;
    int state;
} Apple;

Snake snake;
Queue _q;
Queue* queue = &_q;
Apple apples[MAX_APPLE_COUNT];
int gameOver = 0;
int max_queue_size = FIELD_WIDTH * FIELD_HEIGHT + 1; 
int num_apple = 0;

// ---- Circular Queue ----
void initialize_queue() {
    queue->front = 0;
    queue->rear = 0;
    queue->arr = (Pos*) malloc(sizeof(Pos) * max_queue_size);
}

void enqueue(Pos position) {
    queue->arr[queue->front] = position;
    queue->front = (queue->front + 1) % max_queue_size;

    if (queue->front == queue->rear) {          // overwrite 
        queue->rear = (queue->rear + 1) % max_queue_size;
    }
}

Pos dequeue() {
    Pos ret = queue->arr[queue->rear++];
    queue->rear = queue->rear % max_queue_size; 
    return ret;
}
// ----------------------- 

void set_nonblocking_mode() {
    struct termios ttystate;
    tcgetattr(STDIN_FILENO, &ttystate);
    ttystate.c_lflag &= ~(ICANON | ECHO); // 엔터 없이 입력받기, 입력 글자 안보이게 하기
    ttystate.c_cc[VMIN] = 1;
    tcsetattr(STDIN_FILENO, TCSANOW, &ttystate);

    // 읽기 동작을 비동기(Non-blocking)로 설정
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
}

// ----------------------

void initialize(void) {
    snake.x = FIELD_WIDTH / 2;
    snake.y = FIELD_HEIGHT / 2;
    snake.length = 1;

    initialize_queue();
}

int is_snake(int x, int y, int flag) {
    int i=0, idx;
    if (flag) ++i;
    for (;i<snake.length;i++) {
        idx = (queue->front -1 - i + max_queue_size) % max_queue_size;
        if (queue->arr[idx].x == x
            && queue->arr[idx].y == y)
            return 1;
    }
    return 0;
}

Apple* get_apple_at(int x, int y) {
    for (int i = 0; i < MAX_APPLE_COUNT; i++) {
        if (apples[i].state &&
            apples[i].x == x &&
            apples[i].y == y) {
            return &apples[i];
        }
    }
    return NULL;
}

void spawn_apple() {
    if (num_apple >= MAX_APPLE_COUNT) return;
    if ((float)rand()/RAND_MAX > APPLE_GEN_PROB) return;

    int apple_x = rand() % FIELD_WIDTH;
    int apple_y = rand() % FIELD_HEIGHT;
    if (is_snake(apple_x, apple_y, 0)) return;

    ++num_apple;
    int i;
    for (i=0; i<MAX_APPLE_COUNT; i++) {
        if (apples[i].state == 0) break;
    }
    apples[i].state = 1;
    apples[i].x = apple_x;
    apples[i].y = apple_y;
}

void eat_apple(Apple *apple) {
    --num_apple;
    apple->state = 0;
    ++snake.length;
}

void move(const char c) {
    switch (c) {
        case 'w': snake.y--;  break;
        case 'a': snake.x--;  break;
        case 's': snake.y++;  break;
        case 'd': snake.x++;  break;
        case 'q': gameOver = 1; break;
    }
}

void draw(void) {
    printf("\e[1;1H\e[2J");

    for (int i = 0; i < FIELD_WIDTH + 2; i++) printf("#");
    printf("\n");

    for (int r = 0; r < FIELD_HEIGHT; r++) {
        printf("#");
        for (int c = 0; c < FIELD_WIDTH; c++) {

            if (is_snake(c, r, 0)) {
                printf("■");   // 또는 "O"
            }
            else if (get_apple_at(c, r)) {
                printf(".");
            }
            else {
                printf(" ");
            }

        }
        printf("#\n");
    }

    for (int i = 0; i < FIELD_WIDTH + 2; i++) printf("#");
    printf("\n");
}


int main() {

    set_nonblocking_mode();
    initialize();

    char ch;

    Pos p = {snake.x, snake.y};
    enqueue(p);
    draw();
    printf("Press any key to start...\n");

    fcntl(STDIN_FILENO, F_SETFL,
        fcntl(STDIN_FILENO, F_GETFL) & ~O_NONBLOCK);

    read(STDIN_FILENO, &ch, 1);  // wait for keys
    fcntl(STDIN_FILENO, F_SETFL, fcntl(STDIN_FILENO, F_GETFL) | O_NONBLOCK);

    while(1) {
        
        read(STDIN_FILENO, &ch, 1);
        move(ch);

        Pos p = {snake.x, snake.y};
        if (snake.x >= FIELD_WIDTH || snake.x < 0 || snake.y >= FIELD_HEIGHT || snake.y < 0 || is_snake(snake.x, snake.y, 1)) { // collision with wall & self
            gameOver = 1;
            printf("Game Over!\n");
            break;
        }
        Apple* pA = get_apple_at(snake.x, snake.y);
        if (pA) eat_apple(pA);

        enqueue(p);

        spawn_apple();

        draw();

        printf("Current input : %c\n", ch);
        if (gameOver == 1) break;
        usleep(100000);
    }
    free(queue->arr);
    return 0;
}

