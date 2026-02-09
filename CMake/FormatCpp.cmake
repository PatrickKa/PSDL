cmake_minimum_required(VERSION 3.14)

if(NOT DEFINED FIX)
    set(FIX NO)
endif()

set(flag --output-replacements-xml)
set(args OUTPUT_VARIABLE output)
set(action "Checking")
if(FIX)
    set(flag -i)
    set(args "")
    set(action "Formatting")
endif()

# Here we glob all C++ files that should be formatted
file(GLOB_RECURSE files Cerial/*.[chi]pp Tests/*.[chi]pp)
list(JOIN files "\n  " file_list)
message("${action} the following C++ files:")
message("  ${file_list}\n")

set(badly_formatted "")
set(output "")
foreach(file IN LISTS files)
    execute_process(
        COMMAND clang-format --style=file "${flag}" "${file}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        RESULT_VARIABLE result
        ${args}
    )
    if(NOT result EQUAL "0")
        message(FATAL_ERROR "'${file}': formatter returned ${result}")
    endif()
    if(NOT FIX AND output MATCHES "\n<replacement offset")
        list(APPEND badly_formatted "${file}")
    endif()
    set(output "")
endforeach()

if(NOT badly_formatted STREQUAL "")
    list(JOIN badly_formatted "\n  " bad_list)
    message("The following files are badly formatted:")
    message("  ${bad_list}\n")
    message(FATAL_ERROR "Run again with FIX=YES to fix these files.")
endif()
