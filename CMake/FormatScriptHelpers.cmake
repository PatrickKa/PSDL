# check_cmake_code_formatting(<files_and_directories>...)
#
# Run gersemi to check the formatting of the provided CMake files and directories.
function(check_cmake_code_formatting)
    _run_cmake_code_formatter(FILES_AND_DIRECTORIES ${ARGN})
endfunction()

# check_cpp_code_formatting(<files>...)
#
# Run clang-format to check the formatting of the provided C++ files.
function(check_cpp_code_formatting)
    _run_cpp_code_formatter(FILES ${ARGN})
endfunction()

# format_cmake_code(<files_and_directories>...)
#
# Run gersemi to format the provided CMake files and directories in-place.
function(format_cmake_code)
    _run_cmake_code_formatter(FILES_AND_DIRECTORIES ${ARGN} FIX)
endfunction()

# format_cpp_code(<files>...)
#
# Run clang-format to format the provided C++ files in-place.
function(format_cpp_code)
    _run_cpp_code_formatter(FILES ${ARGN} FIX)
endfunction()

# _run_cmake_code_formatter(FILES_AND_DIRECTORIES <files_and_directories>... [FIX])
function(_run_cmake_code_formatter)
    cmake_parse_arguments(ARG FIX "" FILES_AND_DIRECTORIES ${ARGN})
    if(NOT ARG_FILES_AND_DIRECTORIES)
        message(FATAL_ERROR "No files or directories provided to _run_cmake_code_formatter()")
    endif()

    set(action "Checking")
    set(flag --check)
    if(ARG_FIX)
        set(action "Formatting")
        set(flag --in-place)
    endif()

    list(JOIN ARG_FILES_AND_DIRECTORIES "\n  " files_and_directories)
    message("${action} the following CMake files and directories:")
    message("  ${files_and_directories}\n")

    find_program(formatter gersemi)
    if(NOT formatter)
        message(FATAL_ERROR "Couldn't find 'gersemi'. Ensure it's installed and on your PATH.")
    endif()

    execute_process(
        COMMAND "${formatter}" ${flag} --warnings-as-errors --no-cache ${ARG_FILES_AND_DIRECTORIES}
        RESULT_VARIABLE result
        ERROR_VARIABLE error_output
    )
    if(result EQUAL "0")
        return()
    endif()

    set(badly_formatted_files_regex "([^\n\r]+) would be reformatted[\n\r]*")
    set(badly_formatted_files "")
    if(NOT ARG_FIX)
        string(REGEX MATCHALL ${badly_formatted_files_regex} bad_lines "${error_output}")
        foreach(line IN LISTS bad_lines)
            string(REGEX REPLACE ${badly_formatted_files_regex} "\\1" file "${line}")
            list(APPEND badly_formatted_files "${file}")
        endforeach()
    endif()

    # Print the badly formatted files in a nice list with the same formatting as
    # _run_cpp_code_formatter()
    if(badly_formatted_files)
        _print_badly_formatted_files(${badly_formatted_files})
        string(REGEX REPLACE ${badly_formatted_files_regex} "" error_output "${error_output}")
        string(STRIP "${error_output}" error_output)
        set(error_level SEND_ERROR)
        if(error_output STREQUAL "")
            # If only bad formatting was reported, use FATAL_ERROR to stop at the error message
            # below and do not print the error_output later.
            set(error_level FATAL_ERROR)
        endif()
        # TODO: Think about moving this out of this function and into the calling script
        message(${error_level} "Run again with FIX=YES to fix these files.")
    endif()

    message("${error_output}\n")
    message(FATAL_ERROR "CMake formatter returned ${result}")
endfunction()

# _run_cpp_code_formatter(FILES <files>... [FIX])
function(_run_cpp_code_formatter)
    cmake_parse_arguments(ARG FIX "" FILES ${ARGN})
    if(NOT ARG_FILES)
        message(FATAL_ERROR "No files provided to _run_cpp_code_formatter()")
    endif()

    set(action "Checking")
    set(args OUTPUT_VARIABLE output)
    set(flag --output-replacements-xml)
    if(ARG_FIX)
        set(action "Formatting")
        set(args "")
        set(flag -i)
    endif()

    list(JOIN ARG_FILES "\n  " files)
    message("${action} the following C++ files:")
    message("  ${files}\n")

    find_program(formatter clang-format)
    if(NOT formatter)
        message(FATAL_ERROR "Couldn't find 'clang-format'. Ensure it's installed and on your PATH.")
    endif()

    set(badly_formatted_files "")
    set(output "")
    foreach(file IN LISTS ARG_FILES)
        execute_process(
            COMMAND "${formatter}" --style=file "${flag}" "${file}"
            RESULT_VARIABLE result
            ${args}
        )
        if(NOT result EQUAL "0")
            message(FATAL_ERROR "'${file}': formatter returned ${result}")
        endif()
        if(NOT ARG_FIX AND output MATCHES "\n<replacement offset")
            list(APPEND badly_formatted_files "${file}")
        endif()
        set(output "")
    endforeach()

    if(badly_formatted_files)
        _print_badly_formatted_files(${badly_formatted_files})
        # TODO: Think about moving this out of this function and into the calling script
        message(FATAL_ERROR "Run again with FIX=YES to fix these files.")
    endif()
endfunction()

# _print_badly_formatted_files(<files>...)
function(_print_badly_formatted_files)
    list(JOIN ARGN "\n  " files)
    message("The following files are badly formatted:")
    message("  ${files}\n")
endfunction()
