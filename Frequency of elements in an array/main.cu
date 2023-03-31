#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda.h>

int* A, *arr, *ans;
int *DA, *Darr;

_global_ void findUsingGPUs(int *DA, int *Darr, int n, int total) {	
	 int tid = blockDim.x * blockIdx.x + threadIdx.x;
    for (int i = tid; i < n; i += total) {
        atomicAdd(&Darr[DA[i]], 1);
    }
}

int main(int argc, char* argv[]) {
    srand(0);

    int size=atoi(argv[1]);
    int blocks = atoi(argv[2]);
    int threads = atoi(argv[3]);
    int n = size;

    A = (int*)calloc(n, sizeof(int));
    arr = (int*)calloc(100, sizeof(int));
    // ans = (int*)malloc(100, sizeof(int));

    for (int i = 0; i < n; i++) {
        A[i] = rand()%100;
    }
    for (int i = 0; i < 100; i++) {
        arr[i] = 0;
    }
    cudaMalloc((void **)&DA, sizeof(int)*n);
	cudaMalloc((void **)&Darr, sizeof(int)*100);
    cudaMemcpy(DA, A, sizeof(int)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(Darr, arr, sizeof(int)*100, cudaMemcpyHostToDevice);
    int total = blocks * threads;

    findUsingGPUs<<<blocks, threads>>>(DA, Darr, n, total);
    cudaDeviceSynchronize();
    cudaMemcpy(arr, Darr, sizeof(int)*100, cudaMemcpyDeviceToHost);


    int comp = 0;
    for (int i = 0; i < 100; i++) {
        printf("%d marks : \n", arr[i]);
        comp += arr[i];
    }
    printf("\n\n\nTEST(total no of students) = %d", comp);
}