extends Control

var lowerBound = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Lightnenting.modulate = Color(1,1,1,Global.world.rng.randf_range(lowerBound,1))
	lowerBound -= 0.03
#	pass


func _on_Timer_timeout():
	print("timeout of patches summoner")
	Global.world.get_tree().call_group("SpawnerPatches", "trigger", self)
	pass # Replace with function body.
