#include "stronghold.h"

#ifndef OPEN_SIMPLEX_H
#define OPEN_SIMPLEX_H

typedef struct noise_ctx noise_ctx;

export void open_simplex_noise(i64 seed, noise_ctx **ctx);
export void open_simplex_noise_free(noise_ctx *ctx);
export void open_simplex_noise_init_perm(noise_ctx *ctx, i16 p[], i32 nelements);
export f64 open_simplex_noise2(noise_ctx *ctx, f64 x, f64 y);
export f64 open_simplex_noise3(noise_ctx *ctx, f64 x, f64 y, f64 z);
export f64 open_simplex_noise4(noise_ctx *ctx, f64 x, f64 y, f64 z, f64 w);

#endif //OPEN_SIMPLEX_H
