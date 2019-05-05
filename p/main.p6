use sdl;
use rng;
use SDL2::Raw;
use NativeCall;

sub do_fbnice(CArray[uint8], uint64) is native("stronghold") { ... };

my $sdl = SDL.new("Elven Stronghold", 1280, 720);
my $tex = $sdl.get-tex(1280, 720);
my $done = False;
until $done {
	for $sdl.poll {
		given $_ {
			when *.type == QUIT {
				$done = True;
			}
			default {
			}
		}
	}


	do_fbnice($tex.framebuffer, 1280*720*3);
	$sdl.write-tex($tex, 0, 0);

	$sdl.blit;
}
