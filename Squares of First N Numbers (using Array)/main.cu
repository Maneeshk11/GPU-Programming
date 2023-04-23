#include <stdio.h>
#include <cuda.h>

__global__ void dkernel(int* darr) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	darr[i] = i * i;        
	//printf("%d.\n",i * i);
}

int main(int argc, char** argv) {
	int numBl = atoi(argv[1]);
	int numTh = atoi(argv[2]);
	int *arr, *darr;
	int N = numBl * numTh;
	arr = (int*)calloc(N, sizeof(int));
	cudaMalloc(&darr, sizeof(int) * N);
        dkernel<<<numBl, numTh>>>(darr);
	cudaDeviceSynchronize();
	cudaMemcpy(arr, darr, N*sizeof(int), cudaMemcpyDeviceToHost);
	
	for (int i=0; i<N;i++) {
		printf("%d\n", arr[i]);
	}	
	return 0;
}
