# --- Dependencies ---

find_package(Catch2 CONFIG REQUIRED)
include(Catch)

# --- Tests ---

add_and_set_up_test(CerialTests_Dummy)
target_link_libraries(CerialTests_Dummy PRIVATE Catch2::Catch2WithMain)
catch_discover_tests(CerialTests_Dummy)

# --- End-of-file commands ---

add_folder(Tests)
