unit module sdl;

use SDL2::Raw;
use NativeCall;

use tex;

ENTER die "couldn't initialize SDL2: '{SDL_GetError}'" if SDL_Init(VIDEO) != 0;
LEAVE SDL_Quit;

sub SDL_QueryTexture(SDL_Texture $tex, uint32 $format is rw, int32 $access is rw, int32 $w is rw, int32 $h is rw) is native("SDL2") { * }

class SDL is export {
	has $.window;
	has $.renderer;
	has $.w;
	has $.h;

	method new($title, $w, $h) {
		return self.bless(:$title, :$w, :$h);
	}
	submethod BUILD(:$title, :$w, :$h) {
		$!w = $w;
		$!h = $h;

		$!window = SDL_CreateWindow($title, SDL_WINDOWPOS_UNDEFINED_MASK, SDL_WINDOWPOS_UNDEFINED_MASK, $w, $h, OPENGL +| SHOWN);
		$!renderer = SDL_CreateRenderer($!window, -1, ACCELERATED +| PRESENTVSYNC);
	}

	method blit {
		SDL_RenderPresent($.renderer);
		SDL_RenderClear($.renderer);
	}
	method poll {
		my @ret;
		my SDL_Event $ev .= new;
		while SDL_PollEvent($ev) {
			@ret.append(SDL_CastEvent($ev));
		}
		return @ret;
	}
	method end {
		SDL_DestroyRenderer($.renderer);
		SDL_DestroyWindow($.window);
	}
	method get-tex($w, $h) {
		my Tex $ret .= new(:$w, :$h, tex => SDL_CreateTexture($.renderer, %PIXELFORMAT<RGB24>, STREAMING, $w, $h));

		my int32 $pitch;
		my $pixdatabuf = CArray[int64].new(0, 1234, 1234, 1234);
		my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
		SDL_LockTexture($ret.tex, SDL_Rect, $pixdata, $pitch);
		$ret.framebuffer = nativecast(CArray[uint8], Pointer.new($pixdatabuf[0]));
		return $ret;
	}
	# writes the texture onto the framebuffer at position (x,  y)
	method write-tex($tex is rw, $x, $y) {
		SDL_UnlockTexture($tex.tex);
		SDL_RenderCopy($.renderer, $tex.tex, SDL_Rect, SDL_Rect.new(:$x, :$y, w => $tex.w, h => $tex.h));

		my int32 $pitch;
		my $pixdatabuf = CArray[int64].new(0, 1234, 1234, 1234);
		my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
		SDL_LockTexture($tex.tex, SDL_Rect, $pixdata, $pitch);
		$tex.framebuffer = nativecast(CArray[uint8], Pointer.new($pixdatabuf[0]));
	}
}
