extends "res://Scripts/Misc/Events/LoadTargetResource.gd"

export(Dictionary) var methodArgs = {}


func load_target_resource(by):
	var o = res.instance()
	Global.world.add_child(o)
	if o is Spatial:
		o.global_transform = global_transform
	for i in methodArgs.keys():
		o.call(i, methodArgs[i])
	if deletedTriggerer:
		by.queue_free()
	if deleteSelf:
		queue_free()	
