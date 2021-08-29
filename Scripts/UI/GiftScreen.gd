extends "res://Scripts/UI/InventoryScreen.gd"


func conduct_exchange(i):
	give(i)

func check_if_exchange():
	var i = Utils.pop_item(selected, inventory)
	if i != null and initArgs["giftee"].has_method("get_inventory"):
		conduct_exchange(i)

func clear_context():
	print("clearing context")
	draw_description()
	$Context/GiveButton.visible = false
	#for o in context_buttons:
	#	o.queue_free()
	#context_buttons = []

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

func get_title():
	return "Select a gift for " + initArgs["giftee"].name

func give(i):
	print("getting inventory from ", initArgs["giftee"], initArgs["giftee"].name)
	var inv = initArgs["giftee"].call("get_inventory")
	inv.append(i.duplicate(7))
	draw_list_items()
	clear_context()

func initialize(args = {}):
	print("gift screen: initialize")
	.initialize(args)
	initArgs = Utils.check(args, {"giftee":args.source})
	$Label.text = get_title()

func _on_GiveButton_pressed():
	check_if_exchange()
	pass # Replace with function body.
