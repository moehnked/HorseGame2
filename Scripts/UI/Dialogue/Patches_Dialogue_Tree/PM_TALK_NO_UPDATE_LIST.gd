extends "res://Scripts/UI/Dialogue/Talk.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger():
	print("TALK - NOT UPDATING OPTIONS", i)
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
					print("[()]")
					#ds.speaker.set_options(nextOptions)
			else:
				print("talk:  more lines")
			pass
