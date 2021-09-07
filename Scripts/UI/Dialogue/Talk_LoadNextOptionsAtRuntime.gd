extends "res://Scripts/UI/Dialogue/Talk.gd"

export(Array, String) var nextOptionPathNames = []
var hasInitialized = false

func initialize(args = {}):
	if not hasInitialized:
		for i in nextOptionPathNames:
			print(i)
			nextOptions.append(load(i))
		hasInitialized = true
	.initialize(args)
