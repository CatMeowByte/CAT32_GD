extends CAT32

# Constants for name generation
const VOWELS = ["a", "e", "i", "o", "u"]
const CONSONANTS = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
const WEIGHTED_CONSONANTS = ["z", "f", "q", "r", "x", "v"]
const PREFIXES = [
	"exo", "astro", "terra", "nova", "inter", "neo", "stellar", "galacto", "cryo", "aero",
	"lumino", "chrono", "cyber", "quantum", "spectra", "hyper", "ultra", "electro", "mega", "sub",
	"astro", "exo", "macro", "nano", "psycho", "solar", "lunar", "plasma", "magno", "vortex",
	"proto", "infra", "extra", "radial", "holo", "geo", "bio", "anti", "micro", "meta"
]
const SUFFIXES = [
	"xenia", "prime", "ion", "aria", "ium", "or", "tron", "os", "thia", "dax",
	"etis", "arix", "enix", "alor", "vium", "dora", "zor", "thar", "sion", "plex",
	"nium", "xar", "troid", "phor", "tica", "gen", "polis", "car", "gath", "zon",
	"core", "gate", "phy", "synth", "verse", "drone", "flux", "scope", "nova", "shade"
]

# Current planet name
var current_planet_name = ""

# Generate a sophisticated random name for the planet
func generate_name() -> String:
	var planet_name = ""
	var len_cost = 12
	var word_count = 0
	var max_words = int(random() * 3) + 1

	while not planet_name:
		while word_count < max_words and len_cost > 0:
			if word_count == max_words - 1 and max_words > 1:
				var codename = generate_random_codename()
				if codename["cost"] <= len_cost:
					planet_name += codename["word"]
					len_cost -= codename["cost"]
				else:
					break
			else:
				var normal_word = generate_normal_word(len_cost)
				if normal_word["cost"] <= len_cost:
					planet_name += normal_word["word"]
					len_cost -= normal_word["cost"]
				else:
					break
			if word_count < max_words - 1 and len_cost > 0:
				planet_name += " "
			word_count += 1

		if word_count == 1 and len_cost > 0 and len(planet_name) < 6:
			var filler = generate_normal_word(len_cost)
			planet_name += " " + filler["word"] if len(planet_name) > 0 else filler["word"]

	return planet_name

# Generate a normal word (capitalized)
func generate_normal_word(len_cost: int) -> Dictionary:
	var word = ""
	var cost = 0

	if random() < 0.3 and len_cost > 3:
		var prefix = PREFIXES[int(random() * PREFIXES.size())]
		word += prefix
		cost += prefix.length()

	var core_length = max(2, min(len_cost - cost, int(random() * 6) + 2))
	var use_vowel = false
	for i in range(core_length):
		if use_vowel:
			word += VOWELS[int(random() * VOWELS.size())]
		else:
			if random() < 0.3:
				word += WEIGHTED_CONSONANTS[int(random() * WEIGHTED_CONSONANTS.size())]
			else:
				word += CONSONANTS[int(random() * CONSONANTS.size())]
		use_vowel = not use_vowel
	cost += core_length

	if random() < 0.3 and len_cost - cost > 3:
		var suffix = SUFFIXES[int(random() * SUFFIXES.size())]
		word += suffix
		cost += suffix.length()

	return {"word": word.capitalize(), "cost": cost}

# Generate a codename consisting of letters only
func generate_codename_letter() -> Dictionary:
	var word = ""
	var core_length = max(2, int(random() * 3) + 2)
	var use_vowel = false
	for i in range(core_length):
		if use_vowel:
			word += VOWELS[int(random() * VOWELS.size())]
		else:
			if random() < 0.3:
				word += WEIGHTED_CONSONANTS[int(random() * WEIGHTED_CONSONANTS.size())]
			else:
				word += CONSONANTS[int(random() * CONSONANTS.size())]
		use_vowel = not use_vowel
	return {"word": word.to_upper(), "cost": core_length}

# Generate a codename in the form of MK + number
func generate_codename_mk() -> Dictionary:
	var word = "MK" + str(int(random() * 9) + 1)
	return {"word": word, "cost": 4}

# Generate a codename with key and number (e.g., ZOR-43)
func generate_codename_key() -> Dictionary:
	var word = generate_codename_letter()["word"] + "-" + str(int(random() * 99) + 1)
	return {"word": word, "cost": 6}

# Generate a codename with letter + number (e.g., A328)
func generate_codename_keynum() -> Dictionary:
	var word = CONSONANTS[int(random() * CONSONANTS.size())].to_upper() + str(int(random() * 900) + 100)
	return {"word": word, "cost": 4}

# Generate a codename consisting of only numbers (e.g., 1985)
func generate_codename_order() -> Dictionary:
	var word = str(int(random() * 9000) + 10)
	return {"word": word, "cost": 3}

# Generate a random codename by selecting one of the patterns
func generate_random_codename() -> Dictionary:
	var rand = random()
	if rand < 0.2:
		return generate_codename_letter()
	elif rand < 0.4:
		return generate_codename_mk()
	elif rand < 0.6:
		return generate_codename_key()
	elif rand < 0.8:
		return generate_codename_keynum()
	else:
		return generate_codename_order()

func update():
	if BTN.get_repeat(BTN.ACCEPT):
		current_planet_name = generate_name()
		o(current_planet_name)

# Draw the current planet details
func draw():
	DIS.clear()
	DIS.rect(0, 0, DIS.W, DIS.H, COL.DARK_BLUE, 1)
	DIS.text(0, 0, "Sci-Fi Planet Generator", COL.BLUE)
	DIS.text(0, (DIS.H / 2) - 4, current_planet_name, COL.WHITE)
	DIS.text(0, DIS.H - 8, "Press ACCEPT to regenerate", COL.DARK_GRAY)
