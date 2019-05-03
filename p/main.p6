use sdl;
use rng;
use SDL2::Raw;

my $sdl = SDL.new("hi", 800, 600);
my $tex = $sdl.get-tex(400, 300);
my $done = False;
until $done {
	for $sdl.poll {
		given $_ {
			when *.type == QUIT {
				$done = True;
			}
			default {
				.say;
			}
		}
	}


	my ($fbf, $pitch) = $sdl.get-framebuffer($tex);
	for ^9800 {
		$fbf[$_] = 228;
	}
	$sdl.write-tex($tex, 0, 50);

	$sdl.blit;
}
