extends "res://Scripts/UI/GiftScreen.gd"


func check_if_exchange():
	#print("SellScreen: ", selected, ", ", selected.name, ", ", typeof(selected), ", ", selected is load("res://prefabs/Items/Item.tscn").instance())
	#var i = Utils.pop_item(selected, inventory)
	if initArgs["giftee"].has_method("get_inventory"):
		if initArgs["giftee"].has_method("get_accepted_sell_list"):
			check_sale(initArgs["giftee"].call("get_accepted_sell_list"), selected)
		else:
			conduct_exchange(selected)

func check_sale(validList, i):
	if validList.size() == 0 or validList.has(i.get_name()):
		conduct_exchange(Utils.pop_item(i, inventory))
	else:
		print("SellScreen: INVALID ITEM")
		#initialize(initArgs)

func conduct_exchange(i):
	sourceRef.treats += i.value
	update_treats()
	give(i)
	initialize(initArgs)
	#i.controller.unequip({"returnToInventory": false,})
	#i.queue_free()
	pass

func get_title():
	return "Selling:  " + initArgs["giftee"].name

func terminate():
	initArgs["ds"].exit_trade()
	.terminate()
