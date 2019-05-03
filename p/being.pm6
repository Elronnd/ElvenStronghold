unit module being;

# Motivation is phrased negatively, rather than positively,
# because it seems easier to create desire this way
# But perhaps some of them should be the other way round?
# Perhaps things that are expected should be phrased negatively,
# but those that are not should be positive?
# (But then, *having* an expectation is a positive thing)
module Discontent is export {
	enum <Sexless Hungry Thirsty Tired Bored>
}
module Action is export {
	enum <
		FindAndGrabAnyFood
		FindAndGrabMeatFood
		FindAndGrabVegetableFood
		HarvestAndGrabAnyFood
		HarvestAndGrabMeatFood
		HarvestAndGrabVegetableFood
	> #etc.
}

class Being {
	has $.happiness;

	has $.x; #position
	has $.y;

	has $.aggression;
	has $.age; # or should be dob?
}
