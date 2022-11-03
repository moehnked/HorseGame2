extends "res://Scripts/Objects/SpellSign.gd"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func read_sign(controller):
	.read_sign(controller)
	$TriggerEventByGroup.trigger(self)
