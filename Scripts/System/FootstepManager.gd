extends Node

export(Array, Resource) var grassSFX = []
export(Array, Resource) var dirtSFX = []
export(Array, Resource) var jingleSFX = []
export(Array, Resource) var tileSFX = []
export(Array, Resource) var woodSFX = []
export(Array, Resource) var carpetSFX = []

var stepProg = 0
var walkingOn = "Tile"

func get_sfx_array():
	match walkingOn:
		"Grass":
			return grassSFX
		"Dirt":
			return dirtSFX
		"Tile":
			return tileSFX
		"Wood":
			return woodSFX
		"Carpet":
			return carpetSFX

func increment_step(_walkingOn = "Dirt", stepScale = 12):
	stepProg = (stepProg + stepScale) % 360
	if _walkingOn != walkingOn:
		stepProg = 0
	walkingOn = _walkingOn
	var walkPhase = sin(deg2rad(stepProg))
	if walkPhase == 0:
		step()
		jingle()

func jingle():
	play_sound(Utils.get_random(jingleSFX), $jingle, false)

func play_sound(sfx, stream, scaleRand = true):
	stream.pitch_scale = Utils.rand_float_range(0.5,1.8) if scaleRand else 1
	stream.stream = sfx
	stream.play()

func step(gtype = walkingOn):
	walkingOn = gtype
	play_sound(Utils.get_random(get_sfx_array()), $step)
	stepProg = 0

	
	
