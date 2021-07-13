extends Spatial


var isOpen = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func close():
	isOpen = false
	$DoorClosedMesh.visible = true
	$DoorOpenMesh.visible = false
	$StaticBody/CollisionShape.disabled = false
	

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Close" if isOpen else "Open"
	pass # Replace with function body.


func toggle_open():
	$DoorClosedMesh.visible = !$DoorClosedMesh.visible
	$DoorOpenMesh.visible = !$DoorOpenMesh.visible
	$StaticBody/CollisionShape.disabled =!$DoorClosedMesh.visible
	isOpen = !isOpen


func _on_Interactable_interaction(controller):
	toggle_open()
	pass # Replace with function body.
