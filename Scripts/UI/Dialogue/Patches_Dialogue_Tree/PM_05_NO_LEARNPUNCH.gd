extends "res://Scripts/UI/Dialogue/Talk.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Talk_emit_end_of_lines():
	initArgs["ds"].call("start_exit", false)
	$DialogueEventTrigger.trigger()
	pass # Replace with function body.
