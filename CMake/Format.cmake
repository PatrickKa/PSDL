# This script requires the following formatting scripts to be provided by the user:
#
# - <current-working-directory>/CMake/FormatCpp.cmake
# - <current-working-directory>/CMake/FormatCMake.cmake

cmake_minimum_required(VERSION 3.14)

set(fix_flag "")
if(FIX)
    set(fix_flag -D FIX=YES)
endif()

execute_process(
    COMMAND "${CMAKE_COMMAND}" ${fix_flag} -P CMake/FormatCpp.cmake
    RESULT_VARIABLE cpp_result
)
execute_process(
    COMMAND "${CMAKE_COMMAND}" ${fix_flag} -P CMake/FormatCMake.cmake
    RESULT_VARIABLE cmake_result
)

if(NOT cpp_result EQUAL "0" OR NOT cmake_result EQUAL "0")
    cmake_language(EXIT 1)
endif()
