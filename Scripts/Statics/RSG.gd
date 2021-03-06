extends Node


static func write_word(words):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var a = rng.randi() % words.size()
	return words[a]


static func generate_sentance():
	var art = ["the", "my", "your", "our", "that", "this", "every", "one", "the only", "his", "her"]
	var adj = [
	  "happy", "rotating", "red", "fast", "elastic", "smily", "unbelievable", "infinte", "surprising", "mysterious", "glowing", "green", "blue", "tired", "hard", "soft", "transparent", "long", "short", 
	  "excellent", "noisy", "silent", "rare", "normal", "typical", "living", "clean", "glamorous", "fancy", "handsome", "lazy", "scary", "helpless", "skinny", "melodic", "silly", 
	  "kind", "brave", "nice", "ancient", "modern", "young", "sweet", "wet", "cold", "dry", "heavy", "industrial", "complex", "accurate", "awesome", "shiny", "cool", "glittering", 
	  "fake", "unreal", "naked", "intelligent", "smart", "curious", "strange", "unique", "empty", "gray", "saturated", "blurry"
	]
	var nou = [
	  "forest", "tree", "flower", "sky", "grass", "mountain", "car", "computer", "man", "woman", "dog", "elephant", "ant", "road", "butterfly", "phone", "computer program", "grandma", "school", "bed", 
	  "mouse", "keyboard", "bicycle", "spaghetti", "drink", "cat", "t-shirt", "carpet", "wall", "poster", "airport", "bridge", "road", "river", "beach", "sculpture", "piano", "guitar", "fruit", 
	  "banana", "apple", "strawberry", "rubber band", "saxophone", "window", "mac computer", "skate board", "piece of paper", "photograph", "painting", "hat", "space", "fork", 
	  "mission", "goal", "project", "tax", "wind mill", "light bulb", "microphone", "cpu", "hard drive", "screwdriver", "parrot"
	]

	var ver = [
	  "sings", "dances", "was dancing", "runs", "will run", "walks", "flies", "moves", "moved", "will move", "glows", "glowed", "spins", "promised", "hugs", "cheated", "waits", "is waiting", 
	  "is studying", "swims", "travels", "traveled", "plays", "played", "enjoys", "will enjoy", "illuminates", "arises", "eats", "drinks", "calculates", "kissed", "faded", "listens", 
	  "navigated", "responds", "smiles", "will smile", "will succeed", "is wondering", "is thinking", "is", "was", "will be", "might be", "was never"
	]

	var pre = [
	  "under", "in front of", "above", "behind", "near", "following", "inside", "besides", "unlike", "like", "beneath", "against", "into", "beyond", "without", "with", "towards", "touching"
	]

	var punc = [
	  "...", "?", "!", ".", ",", ";"
	]

	var con = [
	  "even though", "because", "and", "but", "nevertheless", "so", "consequently", "therefore", "despite"
	]
	var sentance = []
	sentance.append(write_word(art))
	sentance.append(write_word(adj))
	sentance.append(write_word(nou))
	sentance.append(write_word(ver))
	sentance.append(write_word(pre))
	sentance.append(write_word(art))
	sentance.append(write_word(nou))
	sentance.append(write_word(punc))
	sentance.append(write_word(con))
	sentance.append(write_word(art))
	sentance.append(write_word(adj))
	sentance.append(write_word(nou))
	sentance.append(write_word(ver))
	sentance.append(write_word(punc))
	return sentance

