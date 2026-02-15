cmake_minimum_required(VERSION 3.14)

if(NOT DEFINED FIX)
    set(FIX NO)
endif()

set(flag "")
if(FIX)
    set(flag -w)
endif()

find_program(codespell_executable codespell)
if(NOT codespell_executable)
    message(FATAL_ERROR "Couldn't find 'codespell'. Ensure it's installed and on your PATH.")
endif()

execute_process(COMMAND "${codespell_executable}" ${flag} RESULT_VARIABLE result)

if(result EQUAL "65")
    message(FATAL_ERROR "Run again with FIX=YES to fix these errors.")
elseif(result EQUAL "64")
    message(FATAL_ERROR "Spell checker printed the usage info. Bad arguments?")
elseif(NOT result EQUAL "0")
    message(FATAL_ERROR "Spell checker returned ${result}")
endif()
