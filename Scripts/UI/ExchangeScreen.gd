extends "res://Scripts/UI/Dialogue/TradingScreen.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func get_button():
	return $Context/TakeButton

func initialize(args = {}):
	args = Utils.check(args, {"vendor":null, "customer":null, "callback":"", "source":null})
	$BG.start()
	customer = args.customer
	vendor = args.vendor
	displayInventory = vendor.get_inventory()
	source = args.source
	callback = args.callback
	$tradingscreen/Label.text = "Exchanging       " + vendor.get_horse_name()
	clear_context()
	Global.InputObserver.subscribe(self)
	var timer = Timer.new()
	timer.connect("timeout",self,"set_can_exit")
	timer.one_shot = true
	add_child(timer) #to process
	timer.start(0.1) #to start
	draw_trading_screen()


func _on_TakeButton_pressed():
	print(self,"TAKE BUTTON PRESSED")
	print(displayInventory)
	if selected != null:
		if vendor.get_equipment_manager().equipped == selected:
			selected = vendor.get_equipment_manager().unequip()
		var a = selected.duplicate(7)
		a.get_context().reset_context()
		a.pickup(customer.get_equipment_manager())
		vendor.get_inventory().erase(selected)
		draw_trading_screen()
		if Utils.contains(selected, vendor.get_inventory()):
			draw_context(Utils.get_item_by_name(selected.get_name(), vendor.get_inventory()))
		else:
			selected.queue_free()
			selected = null
			clear_context()
	pass # Replace with function body.
