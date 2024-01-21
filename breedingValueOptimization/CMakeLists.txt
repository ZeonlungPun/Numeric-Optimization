cmake_minimum_required(VERSION 3.14)
project(BreedingValueOptimization VERSION 1.0)

find_package(ortools CONFIG REQUIRED)

add_executable(BreedingValueOptimization ebv-opt.cpp)
target_link_libraries(BreedingValueOptimization ortools::ortools -larmadillo)
