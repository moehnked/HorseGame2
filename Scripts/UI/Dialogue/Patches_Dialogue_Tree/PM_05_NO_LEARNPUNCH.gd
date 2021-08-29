extends "res://Scripts/UI/Dialogue/Talk.gd"


export(bool) var exitPlayer = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Talk_emit_end_of_lines():
	print("///////endof lines")
	initArgs["ds"].call("start_exit", exitPlayer)
	$DialogueEventTrigger.trigger()
	pass # Replace with function body.
