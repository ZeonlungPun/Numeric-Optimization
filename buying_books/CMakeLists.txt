cmake_minimum_required(VERSION 3.14)
project(bookopt VERSION 1.0)

find_package(ortools CONFIG REQUIRED)

add_executable(buyingbook main.cpp)
target_link_libraries(buyingbook ortools::ortools -larmadillo)

