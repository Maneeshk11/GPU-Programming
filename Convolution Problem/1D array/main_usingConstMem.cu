#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda.h>

int *Arr, *ker, *ans;
int *d_Arr, *d_ker, *d_ans;
int masked_Device;

__global__ void findUsingGPUs(int *d_arr, int *d_ker, int n, int m, int *d_ans) {	
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
    // int masked_Device = m/2;
    int k = blockDim.x * gridDim.x;
    int i = tid;
    int start = i - masked_Device;
    while (i < n) {
        for (int j=0;j<m;j++) {
            if (start >= 0 && start<n) {
                d_ans[i] += d_arr[start]*d_ker[j];

            }
            start++;
        }
        i+=k;
        start = i - maskedLength;
    }        
}

int main(int argc, char* argv[]) {
    // srand(0);

    int n = atoi(argv[1]);
    int m = atoi(argv[2]);
    int blocks = atoi(argv[3]);
    int threads = atoi(argv[4]);
    int number = atoi(argv[5]);

    Arr = (int*)calloc(n, sizeof(int));
    ans = (int*)calloc(n, sizeof(int));
    ker = (int*)calloc(m, sizeof(int));
    // ans = (int*)malloc(100, sizeof(int));

    for (int i = 0; i < n; i++) {
        Arr[i] = 1;
        ans[i] = 0;
    }
    for (int i = 0; i < m; i++) {
        ker[i] = 0;
    }
    int last = m-1;
    while (number > 0) {
        ker[i] = number%2;
        last--;
        number/=2;
    }

    cudaMalloc((void **)&d_Arr, sizeof(int)*n);
    cudaMalloc((void **)&d_ans, sizeof(int)*n);
	cudaMalloc((void **)&d_ker, sizeof(int)*m);

    cudaMemcpy(d_Arr, Arr, sizeof(int)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_ans, ans, sizeof(int)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_ker, ker, sizeof(int)*m, cudaMemcpyHostToDevice);

    // int total = blocks * threads;
    int maskedLength = m/2;
    cudaMemcpyToSymbol(masked_Device, &maskedLength, sizeof(maskedLength));


    findUsingGPUs<<<blocks, threads>>>(d_Arr, d_ker, n, m, d_ans);
    cudaDeviceSynchronize();

    cudaMemcpy(ans, d_ans, sizeof(int)*n, cudaMemcpyDeviceToHost);

    // for (int i = 0; i < n; i++) {
    //     printf("%d ", ans[i]);
    // }
}