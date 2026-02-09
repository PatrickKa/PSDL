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

// template<typename T>
// concept HasEndianness = std::is_integral_v<T> || std::is_enum_v<T>;

// static_assert(HasEndianness<bool>);
// static_assert(HasEndianness<char>);
// static_assert(HasEndianness<int>);
// static_assert(HasEndianness<unsigned long long>);
// static_assert(!HasEndianness<float>);
// static_assert(!HasEndianness<double>);
// static_assert(!HasEndianness<void *>);


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


// Example for user-defined type
namespace example
{
struct S
{
    char c;
    float f;
};
}


// Template specialization must be defined in the same namespace as the primary template
template<>
constexpr auto SerialSize<example::S>() -> std::size_t
{
    return SerialSize<decltype(example::S::c), decltype(example::S::f)>();
}


static_assert(SerialSize<example::S>() == 1 + 4);
}


namespace withadl
{
template<typename T>
constexpr auto SerialSize(T const & t) -> std::size_t;

template<cerial::TriviallySerializable T>
constexpr auto SerialSize(T const &) -> std::size_t  // NOLINT(*named-parameter)
{
    return sizeof(T);
}

template<typename... Ts>
    requires(sizeof...(Ts) > 1)
constexpr auto SerialSize(Ts const &...) -> std::size_t  // NOLINT(*named-parameter)
{
    return (SerialSize<Ts>(std::declval<Ts>()) + ...);
}


static_assert(SerialSize(true) == 1);
static_assert(SerialSize('c') == 1);
static_assert(SerialSize(1) == sizeof(int));
static_assert(SerialSize(1ULL) == sizeof(unsigned long long));
static_assert(SerialSize(0.0F) == sizeof(float));
static_assert(SerialSize(1.0) == sizeof(double));
// static_assert(SerialSize(nullptr) == sizeof(nullptr));  // Error: undefined function
}
