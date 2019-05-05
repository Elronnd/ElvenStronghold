#include <math.h>
#include <time.h>

#include "stronghold.h"

#include "open-simplex.h"

export void do_fbnice(u8 *bytes, u32 w, u32 h) {
	static noise_ctx *ctx = NULL;
	if (ctx == NULL) {
		open_simplex_noise((i64)rand()<<48 | (i64)rand()<<32 | rand()<<16 | rand(), &ctx);
		srand(time(0));
	}

	// colour depth of 3
	for (usz i = 0; i < (w*h*3); i++) {
		bytes[i] = pow(256 * open_simplex_noise3(ctx, 0.05 * ((i/3) % w), 0.05 * (i / (3*w)), get_time()/2), 1.0);
	}
}
