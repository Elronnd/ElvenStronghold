#include <math.h>
#include <time.h>

#include "glad.h"
#include "stronghold.h"

#include "open-simplex.h"

static noise_ctx *ctx;
static RngState state;

typedef struct {
	f32 x, y, z;
} vec3;
typedef struct {
	vec3 a, b, c;
} tri3;
typedef struct {
	GLuint VAO, VBO, program;
} GlState;

GLuint compile_shader(u32 type, const char *src) {
	GLuint ret = glCreateShader(type);

	glShaderSource(ret, 1, &src, 0);
	glCompileShader(ret);

	GLint success = GL_FALSE;
	glGetShaderiv(ret, GL_COMPILE_STATUS, &success);
	if (!success) {
		GLint error_len;
		glGetShaderiv(ret, GL_INFO_LOG_LENGTH, &error_len);
		char *error = alloc(error_len);
		glGetShaderInfoLog(ret, error_len, NULL, error);
		printf("ERROR compiling shader!  OpenGL says '%s'", error);
		abort();
	}

	return ret;
}

export void upload_verts(tri3 *tris, usz num_tris) {
	glBufferData(GL_ARRAY_BUFFER, num_tris * sizeof(tri3), tris, GL_DYNAMIC_DRAW); // options: GL_STATIC_DRAW, GL_DYNAMIC_DRAW, GL_STREAM_DRAW
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(f32), cast(void*)0);
	glEnableVertexAttribArray(0);
}

export void blit_verts(GlState *state, usz num_tris) {
	glUseProgram(state->program);
	glBindVertexArray(state->VAO);
	glDrawArrays(GL_TRIANGLES, 0, num_tris * 3); // 3 points per triangle

	glBindVertexArray(0);
}


export GlState *do_init_vbo(void) {
	GlState *ret = alloc(sizeof(GlState));

	glGenVertexArrays(1, &ret->VAO);
	glBindVertexArray(ret->VAO);
	glGenBuffers(1, &ret->VBO);
	glBindBuffer(GL_ARRAY_BUFFER, ret->VBO);

	GLuint vert = compile_shader(GL_VERTEX_SHADER, "#version 330 core\n" \
			"layout (location = 0) in vec3 pos;\n" \
			"void main() {\n" \
				"gl_Position = vec4(pos.xyz, 1.0);\n" \
			"}\n");
	GLuint frag = compile_shader(GL_FRAGMENT_SHADER, "#version 330 core\n" \
			"out vec4 clr;\n" \
			"void main() {\n" \
				"clr = vec4(0.2, 0.8, 0.3, 1.0);\n" \
			"}\n");
	ret->program = glCreateProgram();

	glAttachShader(ret->program, vert);
	glAttachShader(ret->program, frag);
	glLinkProgram(ret->program);
	glDeleteShader(vert);
	glDeleteShader(frag);

	GLint success = GL_TRUE;
	glGetProgramiv(ret->program, GL_COMPILE_STATUS, &success);
	if (!success) {
		GLint error_len;
		glGetProgramiv(ret->program, GL_INFO_LOG_LENGTH, &error_len);
		char *error = alloc(error_len);
		glGetProgramInfoLog(ret->program, error_len, NULL, error);
		printf("ERROR linking program!  OpenGL says '%s'", error);
		abort();
	}


	return ret;
}


export tri3 *make_vectors(f32 w, f32 h, f32 dist, u32 *num_vecs) {
	usz num = 0;
	for (f32 y = 0; y < h; y += 2 * dist*sin(M_PI/3.0)) {
		for (f32 x = dist; x < w; x+=dist) {
			num++;
		}
	}
	*num_vecs = num;
	return alloc(sizeof(tri3) * num);
}

export void do_fbnice(tri3 *triangles, f32 w, f32 h, f32 dist) {
	if (ctx == NULL) {
		seed_random(&state, time(0), cast(usz)&ctx);
		open_simplex_noise(random(&state), &ctx);
		glClearColor(0, 0, 0, 1);
	}

	usz i = 0;
	/* equilateral triangles with side length 1
	 * so distance between columns of points is 1
	 * Distance between rows is 2sin(60) (or, if you prefer, 2sin(π/3)
	 */

	//
	// 0.5 * dist*dist * sin(pi/3) = 0.5*h*dist
	//
	// h = dist*sin(pi/3)
	//
	for (f32 y = 0; y < h; y += 2 * dist*sin(M_PI/3.0)) {
		for (f32 x = dist; x < w; x+=dist) {
			// converting from screen space coordinates to NDC
			f32 thisy = (y/h - 0.5) * 2;
			f32 thisx = (x/w - 0.5) * 2;
			f32 prevx = ((x-dist)/w - 0.5) * 2;

			f32 downx = (thisx + prevx)/2.0;
			f32 downy = ((y+dist*sin(M_PI/3.0))/h - 0.5) * 2;

			vec3 pt1 = {thisx, thisy, open_simplex_noise3(ctx, 0.08 * thisx, 0.08 * y, get_time()/2)};
			vec3 pt2 = {prevx, thisy, open_simplex_noise3(ctx, 0.08 * prevx, 0.08 * y, get_time()/2)};
			vec3 pt3 = {downx, downy, open_simplex_noise3(ctx, 0.08 * downx, 0.08 * downy, get_time()/2)};
			triangles[i++] = cast(tri3){pt1, pt2, pt3};
		}
	}
}
