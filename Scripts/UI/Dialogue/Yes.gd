extends "res://Scripts/UI/Dialogue/DialogueOption.gd"


export(String) var response = "hello world"
export(Array, Resource) var nextOptions = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger():
	var ds = initArgs["ds"]
	if ds != null:
		if ds.has_method("start_talking"):
			print("talking")
			ds.set_text(response)
			ds.call("start_talking")
			if nextOptions.size() > 0:
				print("loading next options")
				ds.speaker.set_options(nextOptions)
			pass
	pass


func _on_Yes_emit_selected():
	trigger()
	pass # Replace with function body.
