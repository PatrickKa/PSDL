cmake_minimum_required(VERSION 3.31)

include(CMake/InSourceBuildGuard.cmake)

project(
    Cerial
    VERSION 0.1.0
    DESCRIPTION "Patrick's serialization library"
    HOMEPAGE_URL "https://github.com/PatrickKa/Cerial"
    LANGUAGES CXX
)

include(CMake/LanguageStandard.cmake)
include(CMake/AddAndSetUpTargets.cmake)

# ---- Declare targets ----

add_and_set_up_library(Cerial_Cerial INTERFACE)

add_subdirectory(Cerial)

# Convenient targets for developers
if(PROJECT_IS_TOP_LEVEL)
    include(CMake/FormatTargets.cmake)
    include(CMake/SpellTargets.cmake)
endif()
