extends "res://Scripts/UI/Dialogue/DialogueOption.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_emit_selected():
	print("YOU SELECTED exit MOTHERFUCKER")
	var ds = initArgs["ds"]
	if ds != null:
		if ds.has_method("start_talking"):
			ds.call("start_exit")
	pass # Replace with function body.
