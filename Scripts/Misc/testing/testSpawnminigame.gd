extends Timer

var res = preload("res://prefabs/UI/Misc/FishHero.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	get_tree().paused = true
	var c = res.instance()
	get_tree().get_root().add_child(c)
	pass # Replace with function body.
