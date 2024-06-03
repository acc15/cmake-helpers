option(DLL_AUTOCOPY "Automatically copies DLLs to executable directories" ${WIN32})

function(copy_dll_to_target_dir dll_target target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different 
            $<TARGET_FILE:${dll_target}> 
            $<TARGET_FILE_DIR:${target}>
    )
endfunction()

function(copy_dlls_to_target_dir dll_targets target)
    get_target_property(target_libs ${target} LINK_LIBRARIES)
    foreach(dll_target "${dll_targets}")
        if(${dll_target} IN_LIST target_libs)
            copy_dll_to_target_dir(${dll_target} ${target})
        endif()
    endforeach()
endfunction()

function(copy_dlls_to_executable_dirs dll_targets) 
    if (DLL_AUTOCOPY)
        get_directory_property(dir_targets BUILDSYSTEM_TARGETS)
        foreach(target "${dir_targets}")
            get_target_property(target_type ${target} TYPE)
            if(target_type STREQUAL EXECUTABLE)
                copy_dlls_to_target_dir("${dll_targets}" ${target})
            endif()
        endforeach()
    endif()
endfunction()
