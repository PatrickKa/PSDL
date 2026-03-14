/**
 * A short one line description of the file
 *
 * A longer description.
 *
 * May span multiple lines or paragraphs as needed.
 *
 */

#pragma once

#include <MyLibrary/MyLibrary.hpp>

#include <array>
#include <cstddef>

#include "OtherLibrary/Header.hpp"
#include "SomeFile.hpp"


// Brief struct description
struct GlobalStruct
{
    int i;
};


namespace n
{
struct EmptyStruct  // Trailing comment
{};


namespace m
{
struct /* Nobody would place a comment here */ SimpleStruct
{
    char c;
    int i;
    float f;
};
}  // namespace m


namespace a::b
{
template<typename T>
// This is also an unusual place
struct TemplateStruct
{
    int /* As is this one */ i;
    T t;
};


template<typename T, std::/* This is the craziest place I can think of*/ size_t size>
struct ArrayStruct
{
    // Now we are back to normal comments
    std::array<T, size> array;
    int i;  // Also quite normal
};
} /* namespace a::b */
}
