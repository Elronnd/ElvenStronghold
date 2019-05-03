unit module rng;

class WeightedRandom {
	has @.angery;
	has @.weightings;
	has $.total-weighting;
	has $.dynamicdif;
	has $.dynamiquotient;

	# $static and $dynamic are integers representing how static and dynamic the weighting is
	method new(@stuff, $static, $dynamicdif, $dynamiquotient) {
		return self.bless(:@stuff, :$static, :$dynamicdif, :$dynamiquotient);
	}
	submethod BUILD(:@stuff, :$static, :$dynamicdif, :$dynamiquotient) {
		@!angery = @stuff;
		@!weightings = $static xx @!angery;
		$!total-weighting = $static * @!weightings; #or [+] @!weightings
		$!dynamicdif = $dynamicdif;
		$!dynamiquotient = $dynamiquotient;
	}
	method pick {
		my $rng = $!total-weighting.rand;
		for @!weightings.kv -> $i, $v {
			$rng -= $v;

			# found it!
			if ($rng <= 0) {
				# remove this from the running total, update it, add it back to the total
				$!total-weighting -= @!weightings[$i];

				# re-adjust the weightings to account for the fact that we found it
				@!weightings[$i] *= $!dynamiquotient;
				@!weightings[$i] += $!dynamicdif;

				$!total-weighting += @!weightings[$i];

				return @!angery[$i];
			}
		}

		die "wat";
	}
}
