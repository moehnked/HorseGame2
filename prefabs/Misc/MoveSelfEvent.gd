extends "res://Scripts/Misc/Events/GenericEvent.gd"

export var isGlobalOriented = true
export(Vector3) var offset
export(float,-10,10) var weight

var isMoving = false
var goalPos

func _ready():
	goalPos = locale_transform().origin + offset
	._ready()

func _process(delta):
	if isMoving:
		var t = locale_transform()
		t.origin = t.origin.linear_interpolate(goalPos, weight)
		set_locale(t)

func begin_moving(trig):
	isMoving = true

func locale_transform():
	return global_transform if isGlobalOriented else transform

func set_locale(t):
	if isGlobalOriented:
		global_transform = t
	else:
		transform = t

func set(param, val):
	match param:
		"offset":
			offset = Utils.string2vec(val)
		"goalPos":
			goalPos = Utils.string2vec(val)
		_:
			.set(param, val)


