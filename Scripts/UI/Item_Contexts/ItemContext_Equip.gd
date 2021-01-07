extends Control

var item
var controller

func initialize(args = {}):
	args = Utils.check(args, {"item":load("res://prefabs/Items/Equipable.tscn").instance(), "controller":null})
	item = args.item
	controller = args.controller

func _on_TextureButton_button_up():
	if controller.equipped != item:
		#var i = item.duplicate()
		#Utils.remove_item(item, controller.get_inventory())
		print("equipping ", item," to ", controller)
		var g = Utils.instance_item(item)
		Global.world.call_deferred("add_child", g)
		item.interact(controller)
	pass # Replace with function body.
