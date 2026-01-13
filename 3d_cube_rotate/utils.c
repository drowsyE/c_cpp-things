#include <string.h>
// #define OMP

// matrix multiplication, A -> shape MxN, B -> shape NxK
// matrix C should be zero-filled matrix
void matmul_mm(double* A, double* B, double* C, int M, int N, int K) {
    memset(C, 0.0, sizeof(double)*M*K);

    #ifdef OMP
    #pragma omp parallel for
    #endif
    for (int i=0; i<M; i++) {
        for (int k=0; k<N; k++) {
            double e = A[i*N + k];

            #ifdef OMP
            #pragma omp simd
            #endif
            for (int j=0; j<K; j++) {
                C[i*K + j] += e * B[k*K + j];
            }
        }
    }
}