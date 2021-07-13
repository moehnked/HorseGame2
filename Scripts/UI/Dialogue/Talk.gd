extends "res://Scripts/UI/Dialogue/DialogueOption.gd"

var i = 0
export(Array, String) var lines = ["hello world"]
export(Array, Resource) var nextOptions = []

signal emit_end_of_lines()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func close():
	emit_signal("emit_end_of_lines")

func trigger():
	print("YOU SELECTED TALK MOTHERFUCKER - ", i)
	var ds = initArgs["ds"]
	if ds != null:
		if ds.has_method("start_talking"):
			print("talking")
			ds.set_text(lines[i])
			ds.call("start_talking")
			i += 1
			if i > lines.size() - 1:
				#emit_signal("emit_end_of_lines")
				if nextOptions.size() > 0:
					print("loading next options")
					ds.speaker.set_options(nextOptions)
			else:
				print("talk:  more lines")
			pass

func _on_Talk_emit_selected():
	trigger()
	pass # Replace with function body.
