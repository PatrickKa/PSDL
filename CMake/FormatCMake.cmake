cmake_minimum_required(VERSION 3.14)

if(NOT DEFINED FIX)
    set(FIX NO)
endif()

set(action "Checking")
set(flag --check)
if(FIX)
    set(action "Formatting")
    set(flag --in-place)
endif()

set(files_and_directories
    "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/CMake/"
    "${CMAKE_SOURCE_DIR}/Cerial/"
)
list(JOIN files_and_directories "\n  " files_and_directories_list)
message("${action} the following CMake files and directories:")
message("  ${files_and_directories_list}\n")

execute_process(
    COMMAND gersemi ${flag} --warnings-as-errors --no-cache ${files_and_directories}
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    RESULT_VARIABLE result
    ERROR_VARIABLE error_output
)

if(result EQUAL "0")
    return()
endif()

set(badly_formatted_files_regex "([^\n\r]+) would be reformatted[\n\r]*")
set(badly_formatted_files "")
if(NOT FIX)
    string(REGEX MATCHALL ${badly_formatted_files_regex} bad_lines "${error_output}")
    foreach(line IN LISTS bad_lines)
        string(REGEX REPLACE ${badly_formatted_files_regex} "\\1" file "${line}")
        list(APPEND badly_formatted_files "${file}")
    endforeach()
endif()

# Print the badly formatted files in a nice list with the same formatting as FormatCpp.cmake
if(badly_formatted_files)
    string(REGEX REPLACE ${badly_formatted_files_regex} "" error_output "${error_output}")
    string(STRIP "${error_output}" error_output)

    list(JOIN badly_formatted_files "\n  " bad_list)
    message("The following files are badly formatted:")
    message("  ${bad_list}\n")
    set(error_level SEND_ERROR)
    if(error_output STREQUAL "")
        set(error_level FATAL_ERROR)
    endif()
    message(${error_level} "Run again with FIX=YES to fix these files.")
endif()

message("${error_output}\n")
message(FATAL_ERROR "CMake formatter returned ${result}")
