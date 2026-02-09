#pragma once

#include <cstddef>
#include <type_traits>


namespace cerial
{
template<typename T>
concept TriviallySerializable = std::is_arithmetic_v<T> || std::is_enum_v<T>;

static_assert(TriviallySerializable<bool>);
static_assert(TriviallySerializable<char>);
static_assert(TriviallySerializable<int>);
static_assert(TriviallySerializable<unsigned long long>);
static_assert(TriviallySerializable<float>);
static_assert(TriviallySerializable<double>);
static_assert(!TriviallySerializable<void *>);


template<typename T>
constexpr auto SerialSize() -> std::size_t;


template<TriviallySerializable T>
constexpr auto SerialSize() -> std::size_t
{
    return sizeof(T);
}


// TODO: Think about renaming this to TotalSerialSize and constraining to >= 1 types
template<typename... Ts>
    requires(sizeof...(Ts) > 1)
constexpr auto SerialSize() -> std::size_t
{
    return (SerialSize<Ts>() + ...);
}


static_assert(SerialSize<bool>() == 1);
static_assert(SerialSize<char>() == 1);
static_assert(SerialSize<int>() == sizeof(int));
static_assert(SerialSize<unsigned long long>() == sizeof(unsigned long long));
static_assert(SerialSize<bool, char>() == 2);
// static_assert(SerialSize<void *>() == 4);  // "Undefined function 'SerialSize<void *>' ..."
}
