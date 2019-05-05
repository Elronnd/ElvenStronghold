#include <time.h>

#include "stronghold.h"

#include "open-simplex.h"

export void do_fbnice(u8 *bytes, u32 w, u32 h) {
	static noise_ctx *ctx = NULL;
	static RngState state;
	f32 f;
	if (ctx == NULL) {
		seed_random(&state, time(0), cast(usz)&ctx);
		open_simplex_noise(random(&state), &ctx);
	}

	// colour depth of 3
	for (usz i = 0; i < (w*h*3); i++) {
		f=open_simplex_noise3(ctx, 0.02 * ((i/3) % w), 0.02 * (i / (3*w)), get_time()/2);

		// map from [-1, 1] to [0, 1]
		f = f*0.5 + 0.5;

		// to [0, 255] as it's an rgb value
		f *= 255;
		bytes[i] = f * (0.3 * (cast(f64)random(&state)/cast(f64)UINT64_MAX));
	}
}
