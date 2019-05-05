#ifdef _WIN32
# include <windows.h>
#else
# define _POSIX_C_SOURCE 200809L
# include <time.h>
#endif

#include "stronghold.h"

// "stdlib," of sorts
#ifdef _WIN32
f64 get_time(void) {
	i64 time;
	GetSystemTimeAsFileTime((LPFILETIME)&time);

	//wtf windows
	time -= 116444736000000000;
	return time / 10000000.0;
}
#else
f64 get_time(void) {
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
	return ts.tv_sec + ts.tv_nsec / 1000000000.0f;
}
#endif
