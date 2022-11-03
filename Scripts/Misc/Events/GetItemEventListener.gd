extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Resource) var targetitemRes

onready var targetItem = targetitemRes.instance()

func check_item(item):
	if item.get_name() == targetItem.get_name():
		trigger(self)

func set(param, val):
	match param:
		"targetItem":
			pass
		_:
			.set(param,val)
