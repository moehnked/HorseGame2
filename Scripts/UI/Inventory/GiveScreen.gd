extends "res://Scripts/UI/Inventory/SellScreen.gd"

func verify_purchase(i):
	return get_customer().has_method("get_inventory")
		

func trade(i):
	if verify_purchase(i):
		print("giving ", i.get_name(), " to ", get_customer().get_horse_name())
		$Confirm.trigger()
		var c = get_customer()
		c.get_inventory().append(i.duplicate(7))
		#get_vendor().set_treats(get_vendor().get_treats() + i.get_value())
		#$Frame/TreatsCount.set_display(get_vendor().get_treats())
		Utils.remove_item(i, get_vendor().get_inventory())
		draw_list_items()
	else:
		$Error.trigger()
