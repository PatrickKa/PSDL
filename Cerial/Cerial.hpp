#pragma once

#include <array>
#include <cstddef>
#include <type_traits>


namespace cerial
{
// --- Concepts and traits ---

template<typename T>
concept TriviallySerializable = std::is_arithmetic_v<T> || std::is_enum_v<T>;

template<typename T>
inline constexpr auto isStdArray = false;

template<typename T, std::size_t size>
inline constexpr auto isStdArray<std::array<T, size>> = true;

template<typename T>
concept StdArray = isStdArray<T>;


// --- Function declarations ---

// Must be specialized for user-defined types. The primary template is intentionally left undefined,
// so that the compiler will throw an error if the specialization is missing.
template<typename T>
constexpr auto SerialSize() -> std::size_t;

template<TriviallySerializable T>
constexpr auto SerialSize() -> std::size_t;

template<StdArray T>
constexpr auto SerialSize() -> std::size_t;


// --- Function definitions ---

template<TriviallySerializable T>
constexpr auto SerialSize() -> std::size_t
{
    return sizeof(T);
}


template<StdArray T>
constexpr auto SerialSize() -> std::size_t
{
    return SerialSize<typename T::value_type>() * std::tuple_size_v<T>;
}


// --- Compile time checks ---

static_assert(TriviallySerializable<bool>);
static_assert(TriviallySerializable<char>);
static_assert(TriviallySerializable<int>);
static_assert(TriviallySerializable<unsigned long long>);
static_assert(TriviallySerializable<float>);
static_assert(TriviallySerializable<double>);
static_assert(!TriviallySerializable<void *>);

static_assert(SerialSize<bool>() == 1);
static_assert(SerialSize<char>() == 1);
static_assert(SerialSize<int>() == sizeof(int));
static_assert(SerialSize<unsigned long long>() == sizeof(unsigned long long));
// static_assert(SerialSize<void *>() == 4);  // "Undefined function 'SerialSize<void *>' ..."

static_assert(SerialSize<std::array<char, 2>>() == 2);
static_assert(SerialSize<std::array<std::array<float, 2>, 3>>() == 4 * 3 * 2);
}
