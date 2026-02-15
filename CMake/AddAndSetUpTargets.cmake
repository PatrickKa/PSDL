# The functions of this module require the following variables to be pre-defined:
#
# - warning_guard (should be "SYSTEM" or "")
# - default_cxx_standard_feature (e.g. cxx_std_23)
# - linker_script (only for executables on embedded targets)

# add_and_set_up_library(<name> <type>)
#
# - <name> must be of the form <ProjectPrefix>_<Rest>
#
# Add a library according to our CMake conventions, setting its output name, export name, include
# directories and C++ standard, as well as creating an alias target.
function(add_and_set_up_library name type)
    add_library(${name} ${type})
    _split_off_project_prefix(${name} prefix rest)
    add_library(${prefix}::${rest} ALIAS ${name})
    set_target_properties(${name} PROPERTIES OUTPUT_NAME ${rest} EXPORT_NAME ${rest})
    if(type STREQUAL "INTERFACE")
        set(scope INTERFACE)
    else()
        set(scope PUBLIC)
    endif()
    _set_include_directories_and_cxx_standard(${name} ${scope})
endfunction()

# add_and_set_up_executable(<name> [OUTPUT_NAME <output_name>])
#
# - <name> must be of the form <ProjectPrefix>_<Rest>
# - default output name = <Rest>
#
# Add an executable according to our CMake conventions, setting its output name, include
# directories, and C++ standard. On embedded targets, also set the linker script and add post-build
# steps to generate a .bin file and display size information.
function(add_and_set_up_executable name)
    cmake_parse_arguments(ARG "" "OUTPUT_NAME" "" ${ARGN})
    _split_off_project_prefix(${name} prefix rest)
    add_executable(${name})
    if(NOT ARG_OUTPUT_NAME)
        set(ARG_OUTPUT_NAME ${rest})
    endif()
    set_target_properties(${name} PROPERTIES OUTPUT_NAME ${ARG_OUTPUT_NAME})
    _set_include_directories_and_cxx_standard(${name} PRIVATE)
    if(CMAKE_SYSTEM_NAME MATCHES "Generic.*")
        _configure_embedded_executable(${name} ${ARG_OUTPUT_NAME})
    endif()
endfunction()

# add_and_set_up_test(<name> [OUTPUT_NAME <output_name>] [SOURCES <sources>...])
#
# - <name> must be of the form <ProjectPrefix>Tests_<Rest>
# - default output name = <Rest>Test
# - default sources     = <Rest>.test.cpp
#
# Add a test executable according to our CMake conventions, setting its output name, sources,
# include directories, and C++ standard.  On embedded targets, also set the linker script and add
# post-build steps to generate a .bin file and display size information.
function(add_and_set_up_test name)
    cmake_parse_arguments(ARG "" "OUTPUT_NAME" "SOURCES" ${ARGN})
    _remove_test_prefix(${name} rest)
    if(NOT ARG_SOURCES)
        set(ARG_SOURCES ${rest}.test.cpp)
    endif()
    add_executable(${name} ${ARG_SOURCES})
    if(NOT ARG_OUTPUT_NAME)
        set(ARG_OUTPUT_NAME ${rest}Test)
    endif()
    set_target_properties(${name} PROPERTIES OUTPUT_NAME ${ARG_OUTPUT_NAME})
    _set_include_directories_and_cxx_standard(${name} PRIVATE)
    if(CMAKE_SYSTEM_NAME MATCHES "Generic.*")
        _configure_embedded_executable(${name} ${ARG_OUTPUT_NAME})
    endif()
endfunction()

function(_split_off_project_prefix name prefix rest)
    string(REPLACE "_" ";" name_parts "${name}")
    list(LENGTH name_parts n_name_parts)
    if(NOT n_name_parts EQUAL "2")
        message(
            FATAL_ERROR
            "Cannot split off project-specific prefix. '${name}' does not follow the required "
            "format <ProjectPrefix>_<Rest>"
        )
    endif()
    list(GET name_parts 0 prefix_)
    list(GET name_parts 1 rest_)
    set(${prefix} ${prefix_} PARENT_SCOPE)
    set(${rest} ${rest_} PARENT_SCOPE)
endfunction()

function(_remove_test_prefix name rest)
    string(REPLACE "_" ";" name_parts "${name}")
    list(LENGTH name_parts n_name_parts)
    list(GET name_parts 0 prefix)
    if(NOT (n_name_parts EQUAL "2" AND prefix MATCHES ".+Tests$"))
        message(
            FATAL_ERROR
            "Cannot remove test prefix. '${name}' does not follow the required format "
            "<ProjectPrefix>Tests_<Rest>"
        )
    endif()
    list(GET name_parts 1 rest_)
    set(${rest} ${rest_} PARENT_SCOPE)
endfunction()

function(_set_include_directories_and_cxx_standard target scope)
    if(NOT DEFINED warning_guard)
        message(FATAL_ERROR "Variable 'warning_guard' not defined")
    endif()
    if(NOT DEFINED default_cxx_standard_feature)
        message(FATAL_ERROR "Variable 'default_cxx_standard_feature' not defined")
    endif()
    target_include_directories(
        ${target}
        ${warning_guard}
        ${scope}
        "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    )
    target_compile_features(${target} ${scope} ${default_cxx_standard_feature})
endfunction()

function(_configure_embedded_executable name output_name)
    if(NOT linker_script)
        message(FATAL_ERROR "Variable 'linker_script' not defined")
    endif()
    target_link_options(${name} PRIVATE -T "${linker_script}")
    set_target_properties(${name} PROPERTIES LINK_DEPENDS "${linker_script}")
    add_custom_command(
        TARGET ${name}
        POST_BUILD
        COMMAND
            "${CMAKE_OBJCOPY}" -O binary "$<TARGET_FILE:${name}>"
            "$<TARGET_FILE_DIR:${name}>/$<TARGET_FILE_BASE_NAME:${name}>.bin"
        COMMENT "Calling objcopy on ${output_name}.elf to generate ${output_name}.bin"
        VERBATIM
    )
    add_custom_command(
        TARGET ${name}
        POST_BUILD
        COMMAND "${CMAKE_SIZE}" "$<TARGET_FILE:${name}>"
        VERBATIM
    )
endfunction()
