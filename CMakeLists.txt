cmake_minimum_required(VERSION 3.0)

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" )

project( cuda_demo )

add_subdirectory( cuda )

set( EXTRA_LIBS ${EXTRA_LIBS} gpu )

set( SRC main.cpp )

add_executable( cuda_demo ${SRC} )

target_link_libraries( cuda_demo ${EXTRA_LIBS} )
