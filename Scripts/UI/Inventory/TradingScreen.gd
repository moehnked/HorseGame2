extends "res://Scripts/UI/Inventory/BaseInventoryScreen.gd"

var tradeScale = 1

func initialize(args = {}):
	.initialize(args)
	$Frame/MainLabel.text += " " + initArgs['displayName']
	if get_vendor().has_method("get_trainer"):
		if get_vendor().get_trainer() == get_customer():
			tradeScale = 0
		else:
			tradeScale = get_vendor().get_trade_scale()

func get_customer():
	return initArgs['customer']

func get_item_value():
	var i = selected.get_value() * tradeScale
	#i = i * (0 if (get_vendor().trainer == get_customer()) else get_vendor().get_trade_scale())
	return i

func get_vendor():
	return initArgs['vendor']

func verify_purchase(i):
	if get_customer().get_treats() >= get_item_value():
		return true
	else:
		return false

func trade(i):
	selected = i
	if verify_purchase(i):
		$Confirm.trigger()
		var c = get_customer()
		#var purchased = i.duplicate(7)
		var purchased = i
		if purchased.has_method("unequip"):
			#purchased.unequip({"caller":get_vendor().get_equipment_manager()})
			get_vendor().get_equipment_manager().unequip({"returnToInventory": false})
		Utils.remove_item(i, get_vendor().get_inventory())
		var controller = c.get_equipment_manager()
		controller.add_item(purchased)
		c.set_treats(c.get_treats() - get_item_value())
		$Frame/TreatsCount.set_display(c.get_treats())
		var p = i.get_parent()
		if p != null:
			p.remove_child(i)
		draw_list_items()
	else:
		$Error.trigger()
