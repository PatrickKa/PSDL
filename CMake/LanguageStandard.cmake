# Our add_and_set_up_*() functions set the C++ standard via this compile feature for each target.
# This is better than setting CMAKE_CXX_STANDARD because it's propagated as a usage requirement.
set(default_cxx_standard_feature cxx_std_23)
# Always enforce the language constraint
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# We don't need compiler extensions, but let a parent ask for them
if(NOT DEFINED CMAKE_CXX_EXTENSIONS)
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()
# Disable scanning for modules because we don't use them and this causes errors when running clang
# tools while compiling with GCC. (This should fixed once GCC and Clang have better/more similar
# support for modules.)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)
