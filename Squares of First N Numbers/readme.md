# Squares of First N numbers (Basics)

* Here we are going to print the squares of N numbers using GPU. We will be taking the help of the thread and blockI Id's to do this.
* We compile the program using the following command: ``` nvcc main.cu -o main ```
* We can run the program using the following command: ``` ./main <numBl> <numTh> ```. Here "numBl" represent the number of blocks we will launch and "numTh" represents the number of threads we launch per block. 
* N which is the total number of element squares we will find is equal to product of number of blocks and threads we launch. ``` N = numTh * numBl ```.
* Each thread belonging to a block has its own threadId and similarly each block has its own unique blockId. Utilizing these, we can assign every thread to a unique number. We can calculate the number using the following formula: ``` i = blockIdx.x * blockDim.x + threadIdx.x ```. Here "blockIdx.x" represents the block Id in the x-direction. Similarly "threadIdx.x" is the thread id within a block in x-direction. We are referring to them using directions as we we can consider the block to be a 3/n dimensional space. "blockDim.x is the number of threads we are launching per block.
* After executing, we will see the squares of first N elements.  