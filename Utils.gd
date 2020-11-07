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

static func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
