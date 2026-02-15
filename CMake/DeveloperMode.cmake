include(CMake/Folders.cmake)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(Tests)
endif()

option(ENABLE_COVERAGE "Enable generating code coverage reports" OFF)
if(ENABLE_COVERAGE)
    include(CMake/Coverage.cmake)
endif()

# Further options for developers go here

include(CMake/FormatTargets.cmake)
include(CMake/SpellTargets.cmake)

add_folder(Project)
