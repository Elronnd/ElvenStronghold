#include <math.h>
#include <time.h>

#include "stronghold.h"

#include "open-simplex.h"

static noise_ctx *ctx;
static RngState state;

typedef struct {
	f32 r, g, b;
} vec3;

export void do_fbnice(u8 *bytes, u16 w, u16 h, u16 dist) {
	if (ctx == NULL) {
		seed_random(&state, time(0), cast(usz)&ctx);
		open_simplex_noise(random(&state), &ctx);
	}
	/* equilateral triangles with side length 1
	 * so distance between columns of points is 1
	 * Distance between rows is 2sin(60) (or, if you prefer, 2sin(π/3)
	 */

	//
	// 0.5 * dist*dist * sin(pi/3) = 0.5*h*dist
	//
	// h = dist*sin(pi/3)
	//

	bool toggle = 0;
	// colour depth of 3
	for (usz y = 0; y < h; y += ceil(dist*sin(M_PI/3.0))) {
		for (usz x = toggle * 0.5 * dist; x < w; x+=dist) {
			bytes[3*y*w + 3*x + 0] =
			bytes[3*y*w + 3*x + 1] =
			bytes[3*y*w + 3*x + 2] =
				(open_simplex_noise3(ctx, 0.08 * x, 0.08 * y, get_time()/2)*0.5 + 0.5) * 255;
		}
		toggle = !toggle;
	}
}
