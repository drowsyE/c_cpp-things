/*
compile options 
no acceleration : gcc ./matmul.c

Thread parallelism or vectorization(simd)
--------------------
C의 각 행(row)은 서로 독립
i 루프를 스레드에 분배 (i 말고 j 병렬화 x (false sharing))
write 충돌 x → 락 불필요
gcc-15 -fopenmp [-O3 (optimization option)] [-march=native] ./matmul.c -o <name> (gcc-13/15 supports -fopenmp)


*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAT1_N_ROWS 768
#define MAT1_N_COLS 1024 // this
#define MAT2_N_ROWS 1024 // and this should be same!
#define MAT2_N_COLS 768
#define MALLOC_ALIGNMENT 64

#define openmp
#define simd

typedef struct {
    int n_row;
    int n_col;
    int* matrix;
} Matrix;

void matmul(const Matrix* A, const Matrix* B, Matrix* C) {
    if (A->n_col != B->n_row) {
        printf("Shape mismatch!");
        return;
    }

    C->n_row = A->n_row;
    C->n_col = B->n_col;
    int* tmp = realloc(C->matrix, sizeof(int) * C->n_row * C->n_col);

    if (tmp == NULL) {
        printf("Realloc failed!");
        return;
    }
    C->matrix = tmp;
    memset(C->matrix, 0, sizeof(int) * C->n_col * C->n_row);

    #ifdef openmp
    #pragma omp parallel for
    #endif
    for (int i=0; i<A->n_row; i++) {
        for (int k=0; k<A->n_col; k++) {
            int a = A->matrix[i * A->n_col +  k]; // reordered loop for cache hit

            #ifdef simd
            #pragma omp simd
            #endif
            for (int j=0; j<B->n_col; j++) {
                C->matrix[C->n_col * i + j] += a * B->matrix[k * B->n_col + j]; 
            }
        }
    }
}

void print_matrix(Matrix* mat) {
    for (int i=0; i<mat->n_row; i++) {
        for (int j=0; j<mat->n_col; j++) {
            printf("%d ", mat->matrix[i * mat->n_row + j]);
        }
        puts("");
    }
}

void init_random(int* arr, int n_elements) {
    for (int i=0; i<n_elements; i++) {
        arr[i] = rand() % 100;
    }
    
} 

int main() {
    Matrix a, b;
    a.n_row = MAT1_N_ROWS; a.n_col = MAT1_N_COLS;
    b.n_row = MAT2_N_ROWS; b.n_col = MAT2_N_COLS;

    int* matA = aligned_alloc(MALLOC_ALIGNMENT, MAT1_N_ROWS*MAT1_N_COLS*sizeof(int));
    int* matB = aligned_alloc(MALLOC_ALIGNMENT, MAT2_N_ROWS*MAT2_N_COLS*sizeof(int));
    init_random(matA, sizeof(matA)/sizeof(int));
    init_random(matB, sizeof(matB)/sizeof(int));

    a.matrix = matA;
    b.matrix = matB;

    Matrix c = {0};

    struct timespec t0, t1;
    // ------------
    clock_gettime(CLOCK_MONOTONIC, &t0);

    matmul(&a, &b, &c);

    clock_gettime(CLOCK_MONOTONIC, &t1);
    // --------------

    // print_matrix(&c);
    free(c.matrix);
    free(matA);
    free(matB);

    double elapsed_ms =
    (t1.tv_sec  - t0.tv_sec)  * 1000.0 +
    (t1.tv_nsec - t0.tv_nsec) / 1000000.0;
    printf("Time elapsed : %lf(ms)\n", elapsed_ms);
}