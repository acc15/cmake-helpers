
macro(configure_compilers)

    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    
    if(MSVC)
        add_compile_options(
            /W4 # Enable informational warnings (1-4 level)
            /WX # Treat warnings as errors
            /utf-8 # Enable UTF-8 support
            /Zc:wchar_t # wchar_t as builtin type
            /Zc:forScope # Removes possibility to use out of scope loop variables
        
            # Removes unreferenced data or functions that are COMDATs, or that only have internal linkage. 
            # Greatly reduces binary size
            /Zc:inline
        )
    else()
        add_compile_options(-Wall -Wextra -Wpedantic)
    endif()

endmacro()