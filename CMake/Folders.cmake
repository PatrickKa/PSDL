# Call this function at the end of a directory scope to assign a folder to targets created in that
# directory. Utility targets will be assigned to the UtilityTargets folder, otherwise to the
# ${name}Targets folder. If a target already has a folder assigned, then that target will be
# skipped.
function(add_folder name)
    get_property(targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
    foreach(target IN LISTS targets)
        get_property(folder_is_set TARGET "${target}" PROPERTY FOLDER SET)
        if(folder_is_set)
            continue()
        endif()
        set(folder Utility)
        get_target_property(type "${target}" TYPE)
        if(NOT type STREQUAL "UTILITY")
            set(folder "${name}")
        endif()
        set_target_properties("${target}" PROPERTIES FOLDER "${folder}Targets")
    endforeach()
endfunction()
