// vim: ft=c
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
//@portability: this is needed on windows for some reason, idk why
#ifndef static_assert
# define static_assert _Static_assert
#endif

#ifndef STRONGHOLD_H
#define STRONGHOLD_H

typedef uint8_t u8;
typedef int8_t i8;
typedef uint16_t u16;
typedef int16_t i16;
typedef uint32_t u32;
typedef int32_t i32;
typedef uint64_t u64;
typedef int64_t i64;
typedef float f32;
typedef double f64;
//typedef long double f80; //@portability: what about places where long double isn't 80 bits?
			   //atm, this is windows, so it's not practical atm
static_assert(sizeof(f32) == 4, "float is not 32 bits");
static_assert(sizeof(f64) == 8, "double is not 64 bits");

typedef size_t usz;
#ifdef _MSC_VER
# include <BaseTsd.h>
typedef SSIZE_T isz;
#else
# include <sys/types.h>
typedef ssize_t isz;
#endif

// normal types are now illegal
#define t_bad(T) static_assert(false, "Can't use " #T); T
//@cleanup: is it justified to outlaw char?  Maybe it should be used for strings?  Or we should make a typedef for strings above?
#define char t_bad(char)
#define short t_bad(short)
#define int t_bad(int)
#define unsigned t_bad(unsigned)
#define signed t_bad(signed)
#define long t_bad(long)
#define float t_bad(float)
#define double t_bad(double)
#define size_t t_bad(size_t)
#define ssize_t t_bad(ssize_t)

#define alloc(sz) calloc(1, sz)

#ifdef _WIN32
# define export __declspec(dllexport)
#else
# define export
#endif

#endif //STRONGHOLD_H
