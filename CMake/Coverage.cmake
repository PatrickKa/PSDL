if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(GCOV_EXECUTABLE "llvm-cov gcov")
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    string(REPLACE "." ";" GCC_VERSION_LIST "${CMAKE_CXX_COMPILER_VERSION}")
    list(GET GCC_VERSION_LIST 0 GCC_MAJOR_VERSION)
    set(GCOV_EXECUTABLE "gcov-${GCC_MAJOR_VERSION}")
else()
    message(
        FATAL_ERROR
        "Unsupported compiler for generating coverage info: ${CMAKE_CXX_COMPILER_ID}"
    )
endif()
message("Selected Gcov executable: '${GCOV_EXECUTABLE}'")

set(GENERATE_COVERAGE_REPORTS
    gcovr
    --gcov-executable
    "${GCOV_EXECUTABLE}"
    --root
    "${PROJECT_SOURCE_DIR}"
    --txt
    "${PROJECT_BINARY_DIR}/Coverage.txt"
    --html
    --html-details
    "${PROJECT_BINARY_DIR}/CoverageHtml/"
    --html-theme
    github.dark-green
    --cobertura
    "${PROJECT_BINARY_DIR}/Coverage.xml"
    --cobertura-pretty
    CACHE STRING
    "; separated command to generate a text, HTML, and XML report for the 'coverage' target"
)

add_custom_target(
    coverage
    COMMAND ${GENERATE_COVERAGE_REPORTS}
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/MarkdownCoverageReport.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
    COMMENT "Generating text, HTML, XML, and Markdown coverage reports"
    VERBATIM
)
