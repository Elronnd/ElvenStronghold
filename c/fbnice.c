#include <math.h>
#include <time.h>

#include "stronghold.h"

#include "open-simplex.h"

static noise_ctx *ctx1 = NULL, *ctx2 = NULL, *ctx3 = NULL;
static RngState state;

typedef struct {
	f32 r, g, b;
} vec3;

export void do_fbnice(u8 *bytes, u16 w, u16 h, u16 dist) {
	if (ctx1 == NULL) {
		seed_random(&state, time(0), cast(usz)&ctx1);
		open_simplex_noise(random(&state), &ctx1);
		open_simplex_noise(random(&state), &ctx2);
		open_simplex_noise(random(&state), &ctx3);
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
			seed_random(&state, y, y);
			bytes[3*y*w + 3*x + 0] = rnb(&state, 255);
			bytes[3*y*w + 3*x + 1] = rnb(&state, 255);
			bytes[3*y*w + 3*x + 2] = rnb(&state, 255);
		}
		toggle = !toggle;
	}

	//(cast(Px*)bytes)[i].b = (open_simplex_noise3(ctx3, 0.08 * ((i/3) % w), 0.08 * (i / (3*w)), get_time()/2)*0.5 + 0.5) * 255;
}
