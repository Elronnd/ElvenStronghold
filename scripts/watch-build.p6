#!/usr/bin/env perl6
use v6;

sub check-sum($file) {
	(run 'sha256sum', $file, :out).out.slurp(:close).words[0];
}


my %file-hashes;

&*chdir('c');

# all dirs in 'c' that end with '.c' or '.h'
IO::Notification.watch-path('.').act( -> $ev {
	if $ev.path ~~ /\. (c || h) $/|/^Makefile$/ && $ev.event == FileChanged {
		if !($ev.path (elem) %file-hashes.keys) || (check-sum $ev.path) ne %file-hashes{$ev.path} {
			%file-hashes{$ev.path} = check-sum $ev.path;
			run 'clear';
			say "Rebuilding...";
			run "pwsh.exe", "-c", "make", "-j4";
			CATCH {
				default {
					say "Build failed!!";
					print "> ";
				}
			}
			say "\aBuild successful!";
			print "> ";
		}
	}
});

loop {
	given prompt("> ") {
		when "c" { run "make", "clean"; proceed; }
		when "b"|"c" {
			run "pwsh.exe", "-c", "make";

		}
		when "q" { last; }
	}

	CATCH {
		default {
			say "Unknown error.";
			print "> ";
		}
	}
}
