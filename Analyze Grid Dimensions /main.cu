#include <stdio.h>
#include <cuda.h>

__global__ void dkernel() {
    printf("Block: (%d, %d, %d)\tThread: (%d, %d, %d)\n", blockIdx.x, blockIdx.y, blockIdx.z, threadIdx.x, threadIdx.y, threadIdx.z);
}

int main(int argc, char** argv) {
    dim3 grid(2, 2, 2);
    dim3 block(2, 2, 2);

    dkernel<<<grid, block>>>();
    cudaDeviceSynchronize();
}