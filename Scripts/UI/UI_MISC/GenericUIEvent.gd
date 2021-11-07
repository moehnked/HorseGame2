extends Node2D

export(Array, NodePath) var nextEvents = []

signal trigger(trig)
export(bool) var enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func trigger(by):
	print("generic event: ", name, " triggered")
	if enabled:
		emit_signal("trigger", self)
		for i in nextEvents:
			i.trigger(by)
