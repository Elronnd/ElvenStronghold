// vim: ft=c
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef STRONGHOLD_H
#define STRONGHOLD_H

typedef uint8_t u8;
typedef uint8_t i8;
typedef uint16_t u16;
typedef uint16_t i16;
typedef uint32_t u32;
typedef uint32_t i32;
typedef uint64_t u64;
typedef uint64_t i64;
typedef float f32;
typedef double f64;
typedef long double f80;
typedef size_t usz;

#ifdef _MSC_VER
# include <BaseTsd.h>
typedef SSIZE_T isz;
#else
typedef ssize_t isz;
#endif

#define alloc(sz) calloc(1, sz)

#ifdef _WIN32
# define export __declspec(dllexport)
#else
# define export
#endif

#endif //STRONGHOLD_H
