#!/usr/bin/env bash
echo off
echo ; set +v # > NUL
echo ; function GOTO { true; } # > NUL

GOTO WIN
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

cp lib/${lib_prefix}SDL2.$lib_suffix .
cp c/${lib_prefix}stronghold.$lib_suffix .
$P6C -Ip p/main.p6
rm -f ${lib_prefix}SDL2.$lib_suffix
rm -f ${lib_prefix}stronghold.$lib_suffix
exit 0
:win
copy lib\SDL2.dll .
copy c\stronghold.dll .
perl6 -Ip p/main.p6
del SDL2.dll
del stronghold.dll
