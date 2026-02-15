# clang-tidy-cache is a clang-tidy wrapper that caches results of clang-tidy runs. It speeds up
# reanalysis by caching previous results and detecting when the same analysis is being done again.
if(CMAKE_CXX_CLANG_TIDY)
    find_program(CLANG_TIDY_CACHE_PROGRAM "clang-tidy-cache")
    if(CLANG_TIDY_CACHE_PROGRAM)
        message("Found clang-tidy-cache: ${CLANG_TIDY_CACHE_PROGRAM}")
        list(PREPEND CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_CACHE_PROGRAM}")
    else()
        message("clang-tidy-cache not found")
    endif()
endif()
