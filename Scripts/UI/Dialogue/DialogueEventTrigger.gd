extends Node


export(String) var groupname = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger():
	print("GENERIC dialogue EVENT triggered /////")
	Global.world.get_tree().call_group(groupname, "trigger", self)

