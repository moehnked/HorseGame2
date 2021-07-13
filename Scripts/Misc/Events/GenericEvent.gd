extends Spatial


signal emit_event_triggered(by)
export(Array, NodePath) var nextEvent = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger(trig):
	print(name, " triggered by ", trig)
	emit_signal("emit_event_triggered", trig)
	for i in nextEvent:
		var o = get_node(i)
		o.trigger(trig)
