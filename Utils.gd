extends Node

static func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

static func check(args = {}, def = {}):
	var kargs = {}
	for i in def.keys():
		if args.has(i):
			kargs[i] = args[i]
		else:
			kargs[i] = def[i]
	return kargs

static func contains(item, list):
	for i in list:
		if i.itemName == item.itemName:
			return true
	return false

static func count(item, list):
	var c = 0
	for i in list:
		if i.itemName == item.itemName:
			c += 1
	return c

static func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
