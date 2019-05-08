use sdl;
use rng;
use SDL2::Raw;
use NativeCall;

sub do_fbnice(CArray[uint8], uint16, uint16, uint16) is native("stronghold") { ... };
constant $w = 320;
constant $h = 240;

my $sdl = SDL.new("Elven Stronghold", $w, $h);
my $tex = $sdl.get-tex($w, $h);
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


	do_fbnice($tex.framebuffer, $w, $h, 15);
	$sdl.write-tex($tex, 0, 0);

	$sdl.blit;
}
