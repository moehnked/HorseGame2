extends "res://Scripts/UI/InventoryScreen.gd"

func draw_context(item):
	selected = item
	clear_context()
	var c = item.get_context()
	#var buttons = c.get_buttons()
	var d = c.get_description()
	draw_description(d.get_description())
	#var i = 0
	#print("[inv]:drawing context ",buttons)
	#for b in buttons:
	#	print(b.name)
	var o = $Context/GiveButton
	o.initialize({"item":item, "controller":sourceRef.get_equipment_manager()})
	$Context.add_child(o)
	o.visible = true
	#	o.rect_position = $Context/ButtonPoint.rect_position + Vector2((256 * i),0)
	#	i += 1
	context_buttons.append(o)

func initialize(args = {}):
	.initialize(args)
	initArgs = Utils.check(args, {"giftee":args.source})
	$Label.text = "Select a gift for " + initArgs["giftee"].name

func _on_GiveButton_pressed():
	var i = Utils.pop_item(selected, inventory)
	if i != null and initArgs["giftee"].has_method("get_inventory"):
		print("getting inventory from ", initArgs["giftee"], initArgs["giftee"].name)
		var inv = initArgs["giftee"].call("get_inventory")
		inv.append(i)
		draw_list_items()
		clear_context()
	pass # Replace with function body.
