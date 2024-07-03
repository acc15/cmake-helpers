function(testing)
    
    cmake_parse_arguments(PARSE_ARGV 0 TESTING "CUSTOM_MAIN" "NAME;DIR" "TARGETS;SOURCES")
    if(NOT TESTING_NAME)
        set(TESTING_NAME ${PROJECT_NAME}_test)
    endif()
    if(NOT TESTING_DIR)
        set(TESTING_DIR test)
    endif()

    include(CTest)
    if(BUILD_TESTING)

        set(TESTING_LIBS ${TESTING_TARGETS})
        if(TESTING_CUSTOM_MAIN)
            list(PREPEND TESTING_LIBS Catch2::Catch2)
        else()
            list(PREPEND TESTING_LIBS Catch2::Catch2WithMain)
        endif()

        find_package(Catch2 REQUIRED)
        add_executable(${TESTING_NAME} ${TESTING_SOURCES})
        target_include_directories(${TESTING_NAME} PRIVATE ${TESTING_DIR})
        target_link_libraries(${TESTING_NAME} PRIVATE ${TESTING_LIBS})

        include(Catch)
        catch_discover_tests(${TESTING_NAME})

    endif()

endfunction()