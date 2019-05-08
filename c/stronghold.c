#include "glad.h"
#include "stronghold.h"

export bool init_stronghold(void) {
	if (!gladLoadGL()) {
		puts("ERROR! glad was unable to load OpenGL");
		return false;
	}
	printf("Successfully loaded OpenGL version %d.%d/%s\n", GLVersion.major, GLVersion.minor, glGetString(GL_VERSION));

	return true;
}
