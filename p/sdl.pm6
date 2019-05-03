unit module sdl;

use SDL2::Raw;

ENTER die "couldn't initialize SDL2: '{SDL_GetError}'" if SDL_Init(VIDEO) != 0;
LEAVE SDL_Quit;

our class SDL {
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

		$!window = SDL_CreateWindow($title, 0, 0, $w, $h, OPENGL);
		$!renderer = SDL_CreateRenderer($!window, -1, ACCELERATED +| PRESENTVSYNC);
	}

	method blit {
		SDL_RenderPresent($.renderer);
	}
	method poll {
		my SDL_Event $ret;
		if SDL_PollEvent($ret) {
			return $ret;
		} else {
			return SDL_Event:U;
		}
	}
	method end {
		SDL_DestroyRenderer($.renderer);
		SDL_DestroyWindow($.window);
	}
}
