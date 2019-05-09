#include "glad.h"
#include "stronghold.h"

export bool init_stronghold(void) {
	if (!gladLoadGL()) {
		puts("ERROR! glad was unable to load OpenGL");
		return false;
	}
	printf("Successfully loaded OpenGL version %d.%d/%s\n", GLVersion.major, GLVersion.minor, glGetString(GL_VERSION));
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

	return true;
}

export void *alloc(usz sz) {
	void *ret = calloc(1, sz);

	if (ret == NULL) {
		abort();
	}

	return ret;
}
