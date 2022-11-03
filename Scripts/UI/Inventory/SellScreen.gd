extends "res://Scripts/UI/Inventory/TradingScreen.gd"

func initialize(args = {}):
	.initialize(args)
	#$Frame/MainLabel.text += " " + get_customer().get_horse_name()

func verify_purchase(i):
	if get_customer().has_method("get_inventory"):
		if get_customer().has_method("get_accepted_sell_list"):
			return get_customer().call("get_accepted_sell_list").has(i.get_name())
		else:
			return true
	pass

func trade(i):
	if verify_purchase(i):
		$Confirm.trigger()
		var c = get_customer()
		#c.get_inventory().append(i.duplicate(7))
		c.get_equipment_manager().add_item(i.duplicate(7))
		get_vendor().set_treats(get_vendor().get_treats() + i.get_value())
		$Frame/TreatsCount.set_display(get_vendor().get_treats())
		Utils.remove_item(i, get_vendor().get_inventory())
		draw_list_items()
	else:
		$Error.trigger()
