unit module sdl;

use SDL2::Raw;
use NativeCall;

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
		SDL_CreateTexture($.renderer, %PIXELFORMAT<RGB24>, STREAMING, $w, $h);
	}
	method get-framebuffer($tex) {
		my int32 $pitch;
		my $pixdatabuf = CArray[int64].new(0, 1234, 1234, 1234);
		my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
		SDL_LockTexture($tex, SDL_Rect, $pixdata, $pitch);
		return nativecast(CArray[uint8], Pointer.new($pixdatabuf[0])), $pitch;
	}
	# writes the texture onto the framebuffer at position (x,  y)
	method write-tex($tex, $x, $y) {
		SDL_UnlockTexture($tex);
		my int32 ($w, $h);
		my uint32 $pass;
		my uint32 $access = STREAMING;
		SDL_QueryTexture($tex, $pass, $access, $w, $h);
		SDL_RenderCopy($.renderer, $tex, SDL_Rect, SDL_Rect.new(:$x, :$y, :$w, :$h));
	}
}
