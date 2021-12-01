extends Node

var locations = []
export(Resource) var discoverySound

func add_location(loc):
	if not locations.has(loc):
		Global.AudioManager.play_sound(discoverySound, -5)
		#queue context
		Global.InteractionPrompt.show_context("Location Discovered: " + loc)
		#add location
		locations.append(loc)
	pass
