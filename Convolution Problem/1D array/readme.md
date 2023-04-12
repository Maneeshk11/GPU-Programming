## Convolution Problem: Consider that you have a 1D input data and a kernel (which is simply a small array of weights). This kernel “slides” overthe input data, performing an element-wise multiplication with the part ofthe input it is currently on, and then summing up the results into a singleoutput cell.  The kernel repeats this process for every location it slides over,converting a 1D matrix of features into yet another 1D matrix of features.

* Compile the code with the following commands : 
    1. ``` nvcc main.cu -o main ```
    2. ``` ./main <n> <m> <blocks> <threads> <number> ```

* The following are the input parameters:
    1. n : Size of 1d array
    2. m : size of the kernel array
    3. number of blocks
    4. number of threads per block
    5. number the kernel array should be initialized with (in binary form)
