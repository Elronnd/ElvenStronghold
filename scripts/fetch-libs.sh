#!/usr/bin/env bash
SDL2_VER="2.0.10"
SDL2_URL_BASE="https://www.libsdl.org/release/"
SDL2_LIN_URL="https://mirrors.edge.kernel.org/archlinux/extra/os/x86_64/" #sdl website doesn't host linux packages, so I steal arch's
SDL2_WIN_FNAME="SDL2-$SDL2_VER-win32-x64.zip"
SDL2_MAC_FNAME="SDL2-$SDL2_VER.dmg"
SDL2_LIN_FNAME="sdl2-2.0.10-1-x86_64.pkg.tar.xz"

get-cached() {
	fname=`echo $1 | perl -pe 's/.*\/(.+)/\1/g'`
	if [[ ! -d ../.cache ]]; then mkdir ../.cache; fi
	if [[ ! -f ../.cache/$fname ]]; then
		pushd ../.cache >/dev/null
		printf "Fetching $1 from the web..."
		if ! curl -sO $1 2>&1; then
			echo "\nERROR failed to fetch $1 from the web"
			exit 1
		else
			echo 'done!'
		fi
		popd >/dev/null
	else
		echo "Found $fname cached."
	fi
	cp ../.cache/$fname .
}

fetch-win() {
	get-cached $SDL2_URL_BASE$SDL2_WIN_FNAME
	7z -aoa x $SDL2_WIN_FNAME SDL2.dll >/dev/null
	rm -f $SDL2_WIN_FNAME
}
fetch-mac() {
	get-cached $SDL2_URL_BASE$SDL2_MAC_FNAME
	7z -aoa e $SDL2_MAC_FNAME SDL2/SDL2.framework/Versions/A/SDL2 >/dev/null
	mv SDL2 libSDL2.dylib
	rm -f $SDL2_MAC_FNAME
}
fetch-lin() {
	get-cached $SDL2_LIN_URL$SDL2_LIN_FNAME
	tar xf $SDL2_LIN_FNAME --strip-components=2 usr/lib/libSDL2-2.0.so.0.10.0
	mv libSDL2-2.0.so.0.10.0 libSDL2.so
	rm -f $SDL2_LIN_FNAME
}

check-checksums() {
	if ! sha256sum -c <<EOF
200f5b28bc8d7523b48e7046312d1bec8ff8d8f584aece1817cd8f7faf2aeec1  libSDL2.dylib
aaee6eda67b0e2acc09e8792881f014be8a5ac3c2a9ad969b57c9335a5e26123  libSDL2.so
5d66bd7c48a61ff952475ec3492fcad67a81e626d849f00824d2b6442adf8d2f  SDL2.dll
EOF
	then
		return 1
	else
		return 0
	fi
}

rm -rf lib
mkdir lib
pushd lib >/dev/null
fetch-win
fetch-mac
fetch-lin
if ! check-checksums; then
	echo "ERROR!!  Failed to verify the checksums of one or more library binaries"
	echo "Wiping cache and retrying\!"
	rm -rf ../.cache
	fetch-win
	fetch-mac
	fetch-lin
	if ! check-checksums; then
		echo "Unable to verify checksums.  Please figure out wtf is going on."
		exit 1
	fi
fi
popd >/dev/null
exit 0
