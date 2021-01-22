extends "res://Scripts/Items/Throwable.gd"

var basket = null
var prevThrower = null
var thrownFrom:Vector3 = Vector3()

func get_shooter():
	return prevThrower

func set_basket(other):
	basket = other

func throw():
	prevThrower = controller.get_parent()
	thrownFrom = prevThrower.global_transform.origin
	.throw()
