extends Node

export(Array, Resource) var sfx = []
export(NodePath) var audioPlayer

func _ready():
	var a = get_node(audioPlayer)
	a.stream = sfx[Global.world.rng.randi_range(0, sfx.size() - 1)]
	a.pitch_scale = Global.world.rng.randf_range(-1, 2)
	a.play()
	
