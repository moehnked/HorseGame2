extends "res://Scripts/UI/UI_MISC/GenericUIEvent.gd"


export(String) var targetOption


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func trigger(by):
	if by.has_method("get_spell_name"):
		var n = by.call("get_spell_name")
		if n == targetOption:
			print(targetOption, " - TRIGGERED ,", n)
			#emit_signal("trigger", by)
			.trigger(by)
