cmake_minimum_required(VERSION 3.14)
project(TransportConcrete VERSION 1.0)

find_package(ortools CONFIG REQUIRED)

add_executable(TransportConcrete TransportConcrete.cpp)
target_link_libraries(TransportConcrete ortools::ortools -larmadillo)

