cmake_minimum_required( VERSION 3.0 )

project( gpu )

find_package( CUDA )

set( CUDA_NVCC_FLAGS -O3;-G;-g )

file( GLOB_RECURSE SRC_HEADERS *.h *.hpp *.cuh )
file( GLOB SRC *.cu *.cpp )

cuda_add_library( gpu STATIC ${SRC_HEADERS} ${SRC} )
