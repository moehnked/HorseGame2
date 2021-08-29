extends "res://Scripts/UI/Dialogue/Trade.gd"


func trigger():
		initArgs["ds"].start_trade(res, {
			"vendor":initArgs["ds"].speaker, 
			"customer":initArgs["ds"].listener, 
			"source":initArgs["ds"].listener,
			"inv":initArgs["ds"].listener.get_inventory(),
			"giftee":initArgs["ds"].speaker,
			"ds":initArgs["ds"]})
			

