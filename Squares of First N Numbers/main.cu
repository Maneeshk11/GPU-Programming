
#include <stdio.h>
#include <cuda.h>

__global__ void dkernel() {
        int i = blockIdx.x * blockDim.x + threadIdx.x;
    printf("%d.\n",i * i);
}

int main(int argc, char** argv) {
        int numBl = atoi(argv[1]);
        int numTh = atoi(argv[2]);
        dkernel<<<numBl, numTh>>>();
        cudaDeviceSynchronize();
        return 0;
}

