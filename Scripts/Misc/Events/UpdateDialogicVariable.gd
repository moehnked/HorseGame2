extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var varName
export(int) var value

func _on_UpdateDialogicVariable_emit_event_triggered(by):
	Dialogic.set_variable(varName, value)
	pass # Replace with function body.
