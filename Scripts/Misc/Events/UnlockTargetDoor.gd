extends "res://Scripts/Misc/Events/LockTargetDoor.gd"


func effect_door(by):
	var d = get_node(targetDoor)
	d.unlock()
	by.queue_free()
	queue_free()
