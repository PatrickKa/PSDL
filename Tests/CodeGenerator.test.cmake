cmake_minimum_required(VERSION 3.31)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
include(CMakeUnit)
include(CerialCodeGenerator)

set(data_dir "${CMAKE_CURRENT_LIST_DIR}/Data")
cerial_get_structs("${data_dir}/ExampleCode.hpp" structs)
check("GlobalStruct" IN_LIST structs)
check("n::EmptyStruct" IN_LIST structs)
check("n::m::SimpleStruct" IN_LIST structs)
print_test_report()
