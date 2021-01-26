extends "res://Scripts/Items/Item.gd"

export var number = 50
var poplist = []
var ref
var queuedDestroy:bool = false

func _process(delta):
	if queuedDestroy:
		_thread_process({"controller":controller, "ref":ref})
		if number <= 0:
			destroy()
	pass

func interact(_controller):
	controller = _controller
	print("picked up pile of planks")
	ref = load("res://prefabs/Items/Plank.tscn")
	queuedDestroy = true
	$Interactable.isInteractable = false
	pass

func _thread_process(args):
	var obj = args.ref.instance()
	obj.set_pickup_sound("res://Sounds/silence.wav")
	obj.call_deferred("interact", args.controller)
	number -= 1
	pass
