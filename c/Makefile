CC := clang
LD := $(CC)
CFLAGS := -std=c17 -Wall -Wextra -Ofast -ffast-math -finline-functions -c
OBJ := open-simplex.o fbnice.o
HDR := stronghold.h

ifeq ($(OS),Windows_NT)
	LIBNAME := stronghold.dll
else
	CFLAGS := $(CFLAGS) -fPIC
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Darwin)
		LIBNAME := libstronghold.dylib
	else
		LIBNAME := libstronghold.so
	endif
endif

default: all

all: $(LIBNAME)

$(OBJ): $(HDR)

$(LIBNAME): $(OBJ)
	$(LD) -shared -o $(LIBNAME) $(OBJ)

clean:
	rm -f *.o *.dll *.so *.dylib
