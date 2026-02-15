# This file defines all user-configurable options and variables for the project. It also includes
# developer-specific options and variables that must be set before any targets are created.
# Additional developer-specific options and variables should be placed in CMake/DeveloperMode.cmake.

if(PROJECT_IS_TOP_LEVEL)
    # Developer mode enables targets and code paths in the CMake scripts that are only relevant for
    # the developer(s) of Cerial. Targets necessary to build the project must be provided
    # unconditionally, so consumers can trivially build and package the project.
    option(Cerial_DEVELOPER_MODE "Enable developer mode" OFF)

    option(Cerial_ENABLE_CCACHE "Speed up recompilation with ccache" ON)
    if(Cerial_ENABLE_CCACHE)
        include(CMake/CCache.cmake)
    endif()
endif()

if(Cerial_DEVELOPER_MODE)
    option(Cerial_ENABLE_CLANG_TIDY_CACHE "Speed up reanalysis with clang-tidy-cache" ON)
    if(Cerial_ENABLE_CLANG_TIDY_CACHE)
        include(CMake/ClangTidyCache.cmake)
    endif()
endif()

# target_include_directories() with the SYSTEM modifier will request the compiler to omit warnings
# from the provided paths, if the compiler supports that. This is to provide a user experience
# similar to find_package() when add_subdirectory() or FetchContent() is used to consume this
# project.
set(warning_guard "")
if(NOT PROJECT_IS_TOP_LEVEL)
    option(
        Cerial_INCLUDES_WITH_SYSTEM
        "Use SYSTEM modifier for Cerial's includes, disabling warnings"
        ON
    )
    mark_as_advanced(Cerial_INCLUDES_WITH_SYSTEM)
    if(Cerial_INCLUDES_WITH_SYSTEM)
        set(warning_guard SYSTEM)
    endif()
endif()
