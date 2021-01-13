extends Spatial

var isOn:bool = false
export var prompt = ""
var displayData = 0

signal emit_holding(controller)
signal emit_release()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggle_is_on():
	isOn = !isOn
	$OmniLight.visible = isOn


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = prompt + String(displayData)
	pass # Replace with function body.


func _on_Interactable_holding(controller):
	emit_signal("emit_holding", controller)
	pass # Replace with function body.


func _on_Interactable_release():
	emit_signal("emit_release")
	pass # Replace with function body.
