#include "stronghold.h"

export void do_fbnice(uint8_t *bytes, uint64_t len) {
	for (uint64_t i = 0; i < len/2; i++) {
		((uint16_t*)bytes)[i] = rand();
	}
}
