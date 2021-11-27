extends Spatial


signal emit_event_triggered(by)
export(Array, NodePath) var nextEvent = []
export(bool) var deleteAfterTrig = false
export(bool) var triggerOnReady = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if triggerOnReady:
		trigger(self)
	pass # Replace with function body.

func trigger(trig = self):
	print(name, " triggered by ", trig)
	emit_signal("emit_event_triggered", trig)
	for i in nextEvent:
		var o = get_node(i)
		o.trigger(trig)
	if deleteAfterTrig:
		queue_free()


func _on_RemoteButton_interaction(controller):
	trigger(self)
	pass # Replace with function body.
