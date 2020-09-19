cmake_minimum_required(VERSION 3.2)
project(nxjson C)

set(INSTALL_LIB_DIR     lib     CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR     bin     CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH "Installation directory for header files")

if(WIN32 AND NOT CYGWIN)
    set(DEF_INSTALL_CMAKE_DIR CMake)
else()
    set(DEF_INSTALL_CMAKE_DIR lib/CMake/FooBar)
endif()

set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH "Installation directory for CMake files")

foreach(p LIB BIN INCLUDE CMAKE)
    set(var INSTALL_${p}_DIR)
    if(NOT IS_ABSOLUTE "${${var}}")
        set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
    endif()
endforeach()

option(BUILD_SHARED "Builds nxjson as a shared library."    OFF)
option(BUILD_TEST   "Builds the test program."              OFF)

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

export(TARGETS nxjson FILE "${PROJECT_BINARY_DIR}/nxjsonTargets.cmake")
export(PACKAGE nxjson)

file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(nxjsonConfig.cmake.in "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/nxjsonConfig.cmake" @ONLY)

install(FILES "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/nxjsonConfig.cmake" DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

set_target_properties(nxjson PROPERTIES PUBLIC_HEADER "nxjson.h")
install(TARGETS nxjson EXPORT nxjsonTargets RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/nxjson" COMPONENT dev)
install(EXPORT nxjsonTargets DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
