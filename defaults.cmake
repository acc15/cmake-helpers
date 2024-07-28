macro(configure_defaults)

    cmake_parse_arguments(DEFAULTS "WITH_SHARED_LIBS" "" "" "${ARGV}")

    set(CMAKE_CXX_STANDARD 23)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_DEBUG_POSTFIX "d")
    
    if(MSVC)
        add_compile_definitions(
            _CRT_SECURE_NO_WARNINGS # Disable CRT secure warning to allow cross-platform stdlib usage
            NOMINMAX # Removes legacy windef.h min and max macro
        )
        add_compile_options(
            /W4 # Enable informational warnings (1-4 level)
            /WX # Treat warnings as errors
            /utf-8 # Enable UTF-8 support
            /Zc:wchar_t # wchar_t as builtin type
            /Zc:forScope # Removes possibility to use out of scope loop variables
        
            # Removes unreferenced data or functions that are COMDATs, or that only have internal linkage. 
            # Greatly reduces binary size
            /Zc:inline

            # Enables correct __cplusplus version reporting to enable new stdlib++ features
            /Zc:__cplusplus
        )
    else()
        add_compile_options(-Wall -Wextra -Wpedantic -Werror=return-type)
    endif()

    # shared libraries
    if(DEFAULTS_WITH_SHARED_LIBS)
        option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
        option(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS "Exports all symbols from library (Windows only)" ON)
    endif()

    # standard directory path prefixes
    set(SRC src)
    set(INC include)
    set(INCP ${INC}/${PROJECT_NAME})
    set(TEST test)

endmacro()