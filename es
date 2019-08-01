#!/usr/bin/env bash
# WSL
if (cat /proc/version|grep -i microsoft > /dev/null); then
	P6C="powershell.exe -c perl6"
	lib_prefix=
	lib_suffix=dll
else
	P6C=perl6
	lib_prefix=lib
	if [[ $(uname -s) = Darwin ]]; then
		lib_suffix=dylib
	else
		lib_suffix=so
	fi
fi

./scripts/fetch-libs.sh # @ux: this takes about a half a second to complete with a full cache.  Is that too much?  Maybe not; perl6 startup time is already pretty bad

cp lib/${lib_prefix}SDL2.$lib_suffix .
cp c/${lib_prefix}stronghold.$lib_suffix .
LD_LIBRARY_PATH=. $P6C -Ip p/main.p6
rm -f ${lib_prefix}SDL2.$lib_suffix
rm -f ${lib_prefix}stronghold.$lib_suffix
