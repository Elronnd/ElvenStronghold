use sdl;
use rng;
use SDL2::Raw;
use NativeCall;

sub do_fbnice(CArray[uint8], uint32, uint32) is native("stronghold") { ... };

my $sdl = SDL.new("Elven Stronghold", 320, 240);
my $tex = $sdl.get-tex(320, 240);
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


	do_fbnice($tex.framebuffer, 320, 240);
	$sdl.write-tex($tex, 0, 0);

	$sdl.blit;
}
