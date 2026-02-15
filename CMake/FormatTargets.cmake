# This module requires the following formatting scripts to be provided by the user:
#
# - ${PROJECT_SOURCE_DIR}/CMake/FormatCpp.cmake
# - ${PROJECT_SOURCE_DIR}/CMake/FormatCMake.cmake

add_custom_target(
    format-cpp-check
    COMMAND "${CMAKE_COMMAND}" -P CMake/FormatCpp.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Checking code format"
    VERBATIM
)

add_custom_target(
    format-cpp-fix
    COMMAND "${CMAKE_COMMAND}" -D FIX=YES -P CMake/FormatCpp.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Fixing code format"
    VERBATIM
)

add_custom_target(
    format-cmake-check
    COMMAND "${CMAKE_COMMAND}" -P CMake/FormatCMake.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Checking code format"
    VERBATIM
)

add_custom_target(
    format-cmake-fix
    COMMAND "${CMAKE_COMMAND}" -D FIX=YES -P CMake/FormatCMake.cmake
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Fixing code format"
    VERBATIM
)

add_custom_target(
    format-check
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/Format.cmake"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Checking code format"
    VERBATIM
)

add_custom_target(
    format-fix
    COMMAND "${CMAKE_COMMAND}" -D FIX=YES -P "${CMAKE_CURRENT_LIST_DIR}/Format.cmake"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Fixing code format"
    VERBATIM
)
