cmake_minimum_required(VERSION 3.14)

file(WRITE Coverage.md "## Code coverage report\n\n~~~\n")
file(STRINGS Coverage.txt lines)
list(SUBLIST lines 3 -1 lines)
foreach(line IN LISTS lines)
    file(APPEND Coverage.md "${line}\n")
endforeach()
file(APPEND Coverage.md "~~~\n")
