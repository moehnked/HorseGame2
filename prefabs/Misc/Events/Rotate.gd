extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(Vector3) var axis = Vector3(0,1,0)
export(float) var rotAmount = 360
export(float) var weight = 0.1 


var isRotating = false

signal rotation_complete()

func _ready():
	print("rotateableevent ready")
	.connect("emit_event_triggered",self,"start_rotation")

func _process(delta):
	if isRotating:
		rotation_degrees = rotation_degrees.linear_interpolate(axis * rotAmount, weight)

func start_rotation():
	print("starting rotation")
	isRotating = true
