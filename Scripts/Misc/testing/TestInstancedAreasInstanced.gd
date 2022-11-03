extends Node2D

var res = preload("res://scenes/Misc/test/TestInstancedAreas.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var c = res.instance()
	get_tree().get_root().add_child(c)
	pass # Replace with function body.
