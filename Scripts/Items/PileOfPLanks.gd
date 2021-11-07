extends "res://Scripts/Items/Item.gd"

export var number = 50
var poplist = []
var ref
var scale_reduct_rate = 0.02
var queuedDestroy:bool = false
var thread = Thread.new()

func _process(delta):
	if queuedDestroy:
		_thread_process({"controller":controller, "ref":ref})
		scale -= Vector3(scale_reduct_rate,scale_reduct_rate,scale_reduct_rate)
		if number <= 0:
			destroy()
	pass

func interact(_controller):
	controller = _controller
	print("picked up pile of planks")
	ref = load("res://prefabs/Items/Plank.tscn")
	queuedDestroy = true
	$Interactable.isInteractable = false
	Global.world.instantiate("res://prefabs/Effects/SimpleSpray.tscn", global_transform.origin)
	#thread.start(self, "_thread_function", {"controller":controller, "ref":ref})
	pass

func _thread_process(args):
	var obj = args.ref.instance()
	obj.set_pickup_sound("res://Sounds/silence.wav")
	obj.call_deferred("interact", args.controller)
	number -= 1

