extends "res://Scripts/UI/UI_MISC/GenericUIEvent.gd"

signal emit_click()
var selected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func queue_free():
	Global.InputObserver.unsubscribe(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("standard") and selected:
		emit_signal("emit_click")
	pass


func _on_Clickable_mouse_entered():
	print("entered >")
	selected = true
	pass # Replace with function body.


func _on_Clickable_mouse_exited():
	print("exited <")
	selected = false
	pass # Replace with function body.


func _on_Clickable_trigger(trig):
	print("Clickable tirggered")
	emit_signal("emit_click")
	pass # Replace with function body.
