use sdl;
use rng;
use SDL2::Raw;
use NativeCall;

constant stronghold = 'stronghold';

sub do_fbnice(Pointer, num32, num32, num32) is native(stronghold) { ... };
sub init_stronghold returns bool is native(stronghold) { ... };
sub make_vectors(num32 $w, num32 $h, num32 $dist, uint32 $num-tris is rw) returns Pointer is native(stronghold) { ... };
sub do_init_vbo returns Pointer is native(stronghold) { ... };
sub upload_verts(Pointer $verts, size_t $num-tris) is native(stronghold) { ... };
sub blit_verts(Pointer $state, size_t $num-tris) is native(stronghold) { ... };

my num32 $w = 640e0;
my num32 $h = 480e0;
my num32 $dist = 50e0;

my $sdl = SDL.new("Elven Stronghold", $w, $h);
die "Unable to initiate" unless init_stronghold;
my $state = do_init_vbo;
my uint32 $num-verts = 0;
my $verts = make_vectors($w, $h, $dist, $num-verts);

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


	do_fbnice($verts, $w, $h, $dist);
	upload_verts($verts, $num-verts);
	blit_verts($state, $num-verts);
	#$sdl.write-tex($tex, 0, 0);

	$sdl.blit;
}
