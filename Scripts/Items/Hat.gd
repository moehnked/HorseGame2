extends "res://Scripts/Items/Useable.gd"

var rack = null

func set_rack(r):
	rack = r if r == null else r.get_path()

func set(param, val):
	match param:
		"rack":
			rack = val
			if rack != null:
				var r = Global.world.get_node(rack)
				if r != null:
					r.add_hat(self)
		_:
			.set(param, val)
