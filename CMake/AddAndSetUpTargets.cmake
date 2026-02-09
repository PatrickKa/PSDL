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
    if(type STREQUAL INTERFACE)
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
# directories, and C++ standard.
function(add_and_set_up_executable name)
    cmake_parse_arguments(EXECUTABLE "" "OUTPUT_NAME" "" ${ARGN})
    _split_off_project_prefix(${name} prefix rest)
    add_executable(${name})
    if(NOT EXECUTABLE_OUTPUT_NAME)
        set(EXECUTABLE_OUTPUT_NAME ${rest})
    endif()
    set_target_properties(${name} PROPERTIES OUTPUT_NAME ${EXECUTABLE_OUTPUT_NAME})
    _set_include_directories_and_cxx_standard(${name} PRIVATE)
endfunction()

# add_and_set_up_test(<name> [OUTPUT_NAME <output_name>] [SOURCES <sources>...])
#
# - <name> must be of the form <ProjectPrefix>Tests_<Rest>
# - default output name = <Rest>Test
# - default sources     = <Rest>.test.cpp
#
# Add a test executable according to our CMake conventions, setting its output name, sources,
# include directories, and C++ standard.
function(add_and_set_up_test name)
    cmake_parse_arguments(TEST "" "OUTPUT_NAME" "SOURCES" ${ARGN})
    _remove_test_prefix(${name} rest)
    if(NOT TEST_SOURCES)
        set(TEST_SOURCES ${rest}.test.cpp)
    endif()
    add_executable(${name} ${TEST_SOURCES})
    if(NOT TEST_OUTPUT_NAME)
        set(TEST_OUTPUT_NAME ${rest}Test)
    endif()
    set_target_properties(${name} PROPERTIES OUTPUT_NAME ${TEST_OUTPUT_NAME})
    _set_include_directories_and_cxx_standard(${name} PRIVATE)
endfunction()

function(_split_off_project_prefix name prefix rest)
    string(REPLACE "_" ";" name_parts ${name})
    list(LENGTH name_parts n_name_parts)
    if(NOT n_name_parts EQUAL 2)
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
    string(REPLACE "_" ";" name_parts ${name})
    list(LENGTH name_parts n_name_parts)
    list(GET name_parts 0 prefix)
    if(NOT (n_name_parts EQUAL 2 AND prefix MATCHES ".+Tests$"))
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
    target_include_directories(
        ${target}
        ${warning_guard}
        ${scope}
        "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
    )
    target_compile_features(${target} ${scope} ${default_cxx_standard_feature})
endfunction()
