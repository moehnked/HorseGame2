extends Node2D

signal fishing_prompt_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.8,0.8)
	pass # Replace with function body.

func end_animation():
	emit_signal("fishing_prompt_done")
	queue_free()
