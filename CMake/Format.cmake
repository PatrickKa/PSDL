set(fix_flag "")
if(FIX)
    set(fix_flag "-D FIX=YES")
endif()

execute_process(
    COMMAND "${CMAKE_COMMAND}" ${fix_flag} -P CMake/FormatCpp.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    RESULT_VARIABLE cpp_result
)

execute_process(
    COMMAND "${CMAKE_COMMAND}" ${fix_flag} -P CMake/FormatCMake.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    RESULT_VARIABLE cmake_result
)
