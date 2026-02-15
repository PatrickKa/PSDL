file(READ "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg.json" vcpkg_json)
string(
    JSON version_semver_from_vcpkg
    ERROR_VARIABLE version_semver_error
    GET "${vcpkg_json}"
    version-semver
)
string(
    JSON version_date_from_vcpkg
    ERROR_VARIABLE version_date_error
    GET "${vcpkg_json}"
    version-date
)
if(version_semver_error STREQUAL "NOTFOUND")
    set(version_from_vcpkg ${version_semver_from_vcpkg})
elseif(version_date_error STREQUAL "NOTFOUND")
    # vcpkg requires the format YYYY-MM-DD, but CMake requires dot separated version numbers
    string(REPLACE "-" "." version_from_vcpkg "${version_date_from_vcpkg}")
else()
    message(FATAL_ERROR "vcpkg manifest must contain 'version-semver' or 'version-date'")
endif()
string(JSON description_from_vcpkg GET "${vcpkg_json}" description)
string(JSON homepage_from_vcpkg GET "${vcpkg_json}" homepage)
message("Project version:     ${version_from_vcpkg}")
message("Project description: ${description_from_vcpkg}")
message("Project homepage:    ${homepage_from_vcpkg}")
