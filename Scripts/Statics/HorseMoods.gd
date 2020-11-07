enum HorseMoods {heart, diamond, club, spade, greed, bloodlust}

static func random_mood():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi() % 6
