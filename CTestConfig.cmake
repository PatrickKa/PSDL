set(MEMORYCHECK_TYPE Valgrind)
# Read the Valgrind options from .valgrindrc. This is done at configure time so rerun CMake after
# making changes to .valgrindrc. If --errors-for-leak-kinds=all is too strict, try
# --errors-for-leak-kinds=definite
file(READ "${CMAKE_SOURCE_DIR}/.valgrindrc" VALGRIND_OPTIONS)
string(STRIP "${VALGRIND_OPTIONS}" VALGRIND_OPTIONS)
string(REPLACE "\n" " " VALGRIND_OPTIONS "${VALGRIND_OPTIONS}")
string(
    REPLACE
    "--memcheck:suppressions="
    "--memcheck:suppressions=${CMAKE_SOURCE_DIR}/"
    VALGRIND_OPTIONS
    "${VALGRIND_OPTIONS}"
)
set(VALGRIND_COMMAND_OPTIONS "${VALGRIND_OPTIONS}")
