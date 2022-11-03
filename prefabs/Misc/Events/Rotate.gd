extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(float) var weight = 0.01 
export(float) var threshold = 5
export(String) var completionEventGroupTarget = ""
export(Vector3) var targetRotation

var isRotating = false
var rotVec

signal rotation_complete()

func _ready():
	print("rotateableevent ready")
	.connect("emit_event_triggered",self,"start_rotation")
	._ready()

func _process(delta):
	if isRotating:
		rotation_degrees = rotation_degrees.linear_interpolate(targetRotation, weight)
		var rem = rotation_degrees.distance_squared_to(targetRotation)
		#print(rem)
		if rem < pow(threshold,2):
			print("rotation event concluded")
			emit_signal("rotation_complete")
			if completionEventGroupTarget != "":
				Global.world.get_tree().call_group(completionEventGroupTarget, "trigger", self)
			isRotating = false

func set(param, val):
	match param:
		"targetRotation":
			targetRotation = Utils.string2vec(val)
		_:
			.set(param,val)
	pass

func start_rotation(by):
	print("starting rotation")
	isRotating = true

