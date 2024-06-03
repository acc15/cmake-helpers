function(configure_install)
    
    include(GNUInstallDirs)
    include(CMakePackageConfigHelpers)

    set(targets "${ARGN}")
    set(cmake_dir ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})
    set(cmake_config_file ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake)
    set(cmake_version_file ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake)
    set(cmake_targets ${PROJECT_NAME}-targets)
    set(cmake_targets_file ${CMAKE_CURRENT_BINARY_DIR}/${cmake_targets}.cmake)
    set(namespace ${PROJECT_NAME}::)

    configure_dll_autocopy(${cmake_dir})

    configure_package_config_file(
        ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/config.cmake.in ${cmake_config_file}
        INSTALL_DESTINATION ${cmake_dir})

    write_basic_package_version_file(${cmake_version_file} VERSION ${PROJECT_VERSION} COMPATIBILITY ExactVersion)
    install(TARGETS "${targets}" EXPORT ${cmake_targets} LIBRARY FILE_SET HEADERS RUNTIME)
    install(EXPORT ${cmake_targets} DESTINATION ${cmake_dir} NAMESPACE ${namespace})
    install(FILES ${cmake_config_file} ${cmake_version_file} DESTINATION ${cmake_dir})
    export(EXPORT ${cmake_targets} FILE ${cmake_targets_file} NAMESPACE ${namespace})

    foreach(target "${targets}")
        get_target_property(target_type ${target} TYPE)
        if(${target_type} STREQUAL SHARED_LIBRARY OR ${target_type} STREQUAL STATIC_LIBRARY)
            generate_pkgconfig(${target})
        endif()
    endforeach()

endfunction()

function(configure_dll_autocopy cmake_dir)
    set(support_file "dll_autocopy.cmake")
    include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${support_file})
    if(NOT DLL_AUTOCOPY)
        return()
    endif()

    set(dll_targets "")
    foreach(target "${targets}")
        get_target_property(target_type ${target} TYPE)
        if(${target_type} STREQUAL SHARED_LIBRARY)
            LIST(APPEND dll_targets "${namespace}${target}")
        endif()
    endforeach()

    if(NOT dll_targets)
        return()
    endif()


    file(COPY ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${support_file} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    
    string(CONCAT script
        "# DLL autocopy support\n"
        "include(\${CMAKE_CURRENT_LIST_DIR}/${support_file})\n"
        "cmake_language(DEFER CALL copy_dlls_to_executable_dirs \"${dll_targets}\")\n")
    set(DLL_AUTOCOPY_INIT ${script} PARENT_SCOPE)

    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${support_file} DESTINATION ${cmake_dir})
    
endfunction()

function(generate_pkgconfig target)
    set(pkgconfig_template ${CMAKE_CURRENT_BINARY_DIR}/${target}.pc.in)
    set(pkgconfig_dir ${CMAKE_INSTALL_LIBDIR}/pkgconfig)    
    configure_file(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/config.pc.in ${pkgconfig_template} @ONLY)
    file(GENERATE 
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_LINKER_FILE_BASE_NAME:${target}>.pc
        INPUT ${pkgconfig_template}
        TARGET ${target}
    )
    install(
        FILES ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_LINKER_FILE_BASE_NAME:${target}>.pc
        DESTINATION ${pkgconfig_dir}
    )
endfunction()




