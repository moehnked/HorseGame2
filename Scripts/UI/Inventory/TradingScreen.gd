extends "res://Scripts/UI/Inventory/BaseInventoryScreen.gd"

func initialize(args = {}):
	.initialize(args)
	$Frame/MainLabel.text += " " + initArgs['displayName']

func get_customer():
	return initArgs['customer']

func get_vendor():
	return initArgs['vendor']

func verify_purchase(i):
	if get_customer().get_treats() >= i.get_value():
		return true
	else:
		return false

func trade(i):
	if verify_purchase(i):
		$Confirm.trigger()
		var c = get_customer()
		c.get_inventory().append(i.duplicate(7))
		c.set_treats(c.get_treats() - i.get_value())
		$Frame/TreatsCount.set_display(c.get_treats())
		Utils.remove_item(i, get_vendor().get_inventory())
		draw_list_items()
	else:
		$Error.trigger()
