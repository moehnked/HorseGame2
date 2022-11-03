extends "res://Scripts/Nature/Tree.gd"

var fruitProc = 0.1

func generate_fruit():
	rotate_fruit_spawn()
	Global.world.instantiate("res://prefabs/Items/Apple.tscn", $Pivot/fruitSpawn.global_transform.origin)
	fruitProc = 0.1
	pass

func hour_alert(h):
	var roll = Utils.rand_float_range(0.0,1.0)
	if roll < fruitProc:
		generate_fruit()
	else:
		fruitProc += 0.1

func rotate_fruit_spawn():
	$Pivot.rotate_y(deg2rad(Utils.rand_float_range(45,180)))

func save():
	return Utils.serialize_node(self)
