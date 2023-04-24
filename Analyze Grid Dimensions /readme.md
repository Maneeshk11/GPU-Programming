# Analysis of Grid dimensions in 3d.

* Blocks within a grid are launched in 3 dimensions. Each block has a unique Id in x, y, and z-directions. Similarly, within a block threads are launched in 3 dimensions. When the program is excecuted, we can see the block and thread Id's associated with each thread. 
* Use the following command to excecute: ``` nvcc main.cu -o main.o ```  and then ```./main.o ```.
* Within the code the grid and block dimensions can be changed and can be experimented with.