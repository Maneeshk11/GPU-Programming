#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda.h>

int **Arr, **ker, **ans;
int **d_Arr, **d_ker, **d_ans;

__global__ void findUsingGPUs(int **d_arr, int **d_ker, int n, int m, int **d_ans) {	
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int maskedLength = m/2; // mid point of the kernel array
    int k = blockDim.x * gridDim.x;
    int i = tid;
    int start = i - maskedLength;
    while (i < n) {
        for (int j=0;j<m;j++) {
            for (int k=0;k<m;k++) {
                if (start >= 0 && start<n) {
                    d_ans[i] += d_arr[start]*d_ker[j];

                }
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

    Arr = (int **)calloc(sizeof(int *), n);
    ans = (int **)calloc(sizeof(int *), n);
    ker = (int **)calloc(sizeof(int *), m);

    for(int i=0;i<n;i++) {
		Arr[i]=(int *)calloc(sizeof(int), n);
		ans[i]=(int *)calloc(sizeof(int), n);
	}
    for (int i=0;i<m;i++)  {
        ker[i] = (int *)calloc(sizeof(int), m);
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            Arr[i][j] = 1;
            ans[i][j] = 0;
        }
    }

    for (int i = 0; i < m; i++) {
        for (int j=0;j<m;j++) {
            ker[i][j] = 1;
        }
    }

    cudaMalloc((void***)&d_Arr,  n*sizeof(int *));
    cudaMalloc((void***)&d_ans,  n*sizeof(int *));
    cudaMalloc((void***)&d_ker,  m*sizeof(int *));

    for (int i = 0; i < n; i++) {
        cudaMalloc((void**) &(d_Arr[i]), n*sizeof(int));
        cudaMemcpy (d_Arr[i], Arr[i], n*sizeof(int), cudaMemcpyHostToDevice);
        cudaMalloc((void**) &(d_ans[i]), n*sizeof(int));
        cudaMemcpy (d_ans[i], ans[i], n*sizeof(int), cudaMemcpyHostToDevice);
    }
    for (int i=0;i<m;i++) {
        cudaMalloc((void**) &(d_ker[i]), m*sizeof(int));
        cudaMemcpy (d_ker[i], ker[i], m*sizeof(int), cudaMemcpyHostToDevice);
    }

    // int total = blocks * threads;
    // int maskedLength = m/2;

    findUsingGPUs<<<blocks, threads>>>(d_Arr, d_ker, n, m, d_ans);
    cudaDeviceSynchronize();

    for (int i=0;i<n;i++) {
        cudaMemcpy(ans[i], d_ans[i], sizeof(int)*n, cudaMemcpyDeviceToHost);
    }

    

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++){
            printf("%d ", ans[i][j]);
        }
        printf("\n");
    }
}