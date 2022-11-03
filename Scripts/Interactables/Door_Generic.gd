extends Spatial


var isOpen = false
var canOpen = true

signal door_state_changed(door)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func close():
	isOpen = false
	$DoorClosedMesh.visible = true
	$DoorOpenMesh.visible = false
	$StaticBody/CollisionShape.disabled = false

func get_prompt():
	return "Close" if isOpen else "Open"

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = get_prompt()
	pass # Replace with function body.


func toggle_open():
	$DoorClosedMesh.visible = !$DoorClosedMesh.visible
	$DoorOpenMesh.visible = !$DoorOpenMesh.visible
	$StaticBody/CollisionShape.disabled =!$DoorClosedMesh.visible
	isOpen = !isOpen
	emit_signal("door_state_changed", self)


func _on_Interactable_interaction(controller):
	if canOpen:
		toggle_open()
	pass # Replace with function body.
