extends Spatial


var isOpen = false
var promptRef = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Close" if isOpen else "Open"
	promptRef = _prompt
	pass # Replace with function body.


func toggle_open():
	$DoorClosedMesh.visible = !$DoorClosedMesh.visible
	$DoorOpenMesh.visible = !$DoorOpenMesh.visible
	$StaticBody/CollisionShape.disabled =!$DoorClosedMesh.visible
	isOpen = !isOpen

func _on_Interactable_interaction(controller):
	toggle_open()
	pass # Replace with function body.
