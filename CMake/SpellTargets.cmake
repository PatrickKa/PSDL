add_custom_target(
    spell-check
    COMMAND "${CMAKE_COMMAND}" -P "${PROJECT_SOURCE_DIR}/CMake/Spell.cmake"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Checking spelling"
    VERBATIM
)

add_custom_target(
    spell-fix
    COMMAND "${CMAKE_COMMAND}" -D FIX=YES -P "${PROJECT_SOURCE_DIR}/CMake/Spell.cmake"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    COMMENT "Fixing spelling errors"
    VERBATIM
)
