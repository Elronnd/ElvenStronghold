CC := clang
LD := $(CC)
# the keyword-macro warning occurs when you try to use a macro to redefine a keyword (like 'int')
# you're not supposed to do that.  But I want to  ¯\_(ツ)_/¯
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wno-keyword-macro -Werror -Ofast -ffast-math -finline-functions -c
LFLAGS :=
OBJ := fbnice.o open-simplex.o pcg.o time.o
HDR := open-simplex.h stronghold.h

ifeq ($(OS),Windows_NT)
	LIBNAME := stronghold.dll
	LFLAGS := $(LFLAGS) -Wl,/noimplib
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
	$(LD) -shared $(OBJ) -o $(LIBNAME) $(LFLAGS)

clean:
	rm -f *.o *.dll *.so *.dylib
