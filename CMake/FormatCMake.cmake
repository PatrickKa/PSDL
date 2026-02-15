cmake_minimum_required(VERSION 3.20)

cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH project_root_dir)
list(APPEND CMAKE_MODULE_PATH "${project_root_dir}/CMake")

include(FormatScriptHelpers)

set(files_and_directories
    "${project_root_dir}/CMakeLists.txt"
    "${project_root_dir}/CTestConfig.cmake"
    "${project_root_dir}/CMake/"
    "${project_root_dir}/Cerial/"
    "${project_root_dir}/Tests/"
)
if(FIX)
    format_cmake_code(${files_and_directories})
else()
    check_cmake_code_formatting(${files_and_directories})
endif()
