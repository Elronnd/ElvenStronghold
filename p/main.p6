use sdl;
use rng;
use SDL2::Raw;
use NativeCall;

sub do_fbnice(CArray[uint8], uint16, uint16, uint16) is native("stronghold") { ... };
sub init_stronghold returns bool is native("stronghold") { ... };
constant $w = 1280;
constant $h = 720;

my $sdl = SDL.new("Elven Stronghold", $w, $h);
die "Unable to initiate" unless init_stronghold;

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
