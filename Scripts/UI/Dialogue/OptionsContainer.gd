extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear_options():
	for i in get_children():
		remove_child(i)
		i.queue_free()
		

func _on_DialogueScreen_tree_exiting():
	for i in get_children():
		i.call("queue_free")
	pass # Replace with function body.
