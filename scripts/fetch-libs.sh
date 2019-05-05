#!/usr/bin/env bash
SDL2_VER="2.0.9"
SDL2_URL_BASE="https://www.libsdl.org/release/"
SDL2_LIN_URL="https://mirrors.edge.kernel.org/archlinux/extra/os/x86_64/" #sdl website doesn't host linux packages, so I steal arch's
SDL2_WIN_FNAME="SDL2-$SDL2_VER-win32-x64.zip"
SDL2_MAC_FNAME="SDL2-$SDL2_VER.dmg"
SDL2_LIN_FNAME="sdl2-2.0.9-1-x86_64.pkg.tar.xz"

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
	tar xf $SDL2_LIN_FNAME --strip-components=2 usr/lib/libSDL2-2.0.so.0.9.0
	mv libSDL2-2.0.so.0.9.0 libSDL2.so
	rm -f $SDL2_LIN_FNAME
}

check-checksums() {
	if ! sha256sum -c <<EOF
2c01d7de4de91278c6f895271a0aaa8fa6e20f3f121771ff43687331a528c9a7  libSDL2.dylib
f6dedd799cdbc2189976d37daaa23434d0bca79411ac31278e414e1585f4f901  libSDL2.so
b5b603fd71086b15a81fb294297f634d242519828ba0f20d027d8a2a4d8c4f70  SDL2.dll
EOF
	then
		echo "ERROR!!  Failed to verify the checksums of one or more files"
		exit 1
	fi
}

rm -rf lib
mkdir lib
pushd lib >/dev/null
fetch-win
fetch-mac
fetch-lin
check-checksums
popd >/dev/null
