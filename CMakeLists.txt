cmake_minimum_required(VERSION 3.2)
project(nxjson C)

option(BUILD_SHARED "Builds nxjson as a shared library." OFF)
option(BUILD_TEST "Builds the test program." OFF)

if(BUILD_SHARED)
    set(BUILD_MODE SHARED)
else()
    set(BUILD_MODE STATIC)
endif()

add_library(nxjson ${BUILD_MODE}
    ${CMAKE_CURRENT_LIST_DIR}/nxjson.h
    ${CMAKE_CURRENT_LIST_DIR}/nxjson.c
)

if(BUILD_TEST)
    add_subdirectory(test)
endif()
