extends Area

var isInteractable = true
export var path = "res://prefabs/Items/Plank.tscn"
export var prompt = "Plank"

func interact(controller):
	print("creating ", prompt, "...")
	var obj = load(path).instance()
	Global.world.call_deferred("add_child", obj)
	obj.global_transform.origin = $SpawnPoint.global_transform.origin


func prompt():
	return "Create " + prompt
