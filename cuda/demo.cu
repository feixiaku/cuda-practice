#include <stdio.h>
#include <iostream>
#include <cuda.h>
#include <vector>
#include "demo.cuh"

__global__ void add_kernel(float* A, float* B, float* C)
{
    const unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    C[idx] = A[idx] + B[idx];
    //printf("%d\n", C[idx]);
}

int testCUDA()
{
    int num = 100;
    float a[num];
    float b[num];
    float c[num];
    float a_test[num];
    
    std::vector<float> a_vec;
    std::vector<float> b_vec;
    std::vector<float> c_vec;

    int block_num = 20;
    int block_size = num / block_num;
    cudaError_t cudaStatus;

    for (int i = 0; i < num; i++)
    {
        a[i] = i;
        b[i] = i;
        //a_vec.push_back(i);
        //b_vec.push_back(i);
        a_vec.emplace_back(i);
        b_vec.emplace_back(i);
    }

    float *a_d, *b_d, *c_d;
    cudaMalloc((void **)&a_d, sizeof(float) * num);
    cudaMalloc((void **)&b_d, sizeof(float) * num);
    cudaMalloc((void **)&c_d, sizeof(float) * num);
 
    //cudaMemcpy(a_d, a, num * sizeof(float), cudaMemcpyHostToDevice);
    //cudaMemcpy(b_d, b, num * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(a_d, a_vec.data(), num * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b_vec.data(), num * sizeof(int), cudaMemcpyHostToDevice);

    add_kernel<<<block_num, block_size>>>(a_d, b_d, c_d);
    
    cudaStatus = cudaGetLastError();
    if(cudaStatus != cudaSuccess)
    {
        std::cout << "add_kernel failed: " << cudaGetErrorString(cudaStatus) << std::endl;
        goto Error;
    }
    //cudaThreadSynchronize(); 
    
    cudaStatus = cudaMemcpy(a_test, a_d, num * sizeof(int), cudaMemcpyDeviceToHost);
    if(cudaStatus != cudaSuccess)
    {
        std::cout << "cuda memcpy failed: " << cudaGetErrorString(cudaStatus) << std::endl;
        goto Error;
    }

    for (int i=0; i<num; i++)
    {
        std::cout << i << ": " << *(a_test + i) << std::endl;
    }

    cudaStatus = cudaMemcpy(c, c_d, num * sizeof(int), cudaMemcpyDeviceToHost);
    if(cudaStatus != cudaSuccess)
    {
        std::cout << "cuda memcpy failed: " << cudaGetErrorString(cudaStatus) << std::endl;
        goto Error;
    }


    for (int i = 0; i < num; i++)
    {
    	//std::cout << "c[" << i << "]: " << c[i] << std::endl;
    }

Error:
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
    return 0;
}
