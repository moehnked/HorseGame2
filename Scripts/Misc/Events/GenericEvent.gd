#extends "res://Scripts/Persistent.gd"
extends Spatial


signal emit_event_triggered(by)
export(Array, NodePath) var nextEvent = []
export(bool) var deleteAfterTrig = false
export(bool) var triggerOnReady = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persist")
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
		queue_delete()

func save():
	var ne = []
	for n in nextEvent:
		var e = get_node(n)
		if e != null:
			ne.append(e.get_path())
	return Utils.serialize_node(self, {"nextEvent": ne} if ne.size() > 0 else {})

func queue_delete():
	Utils.report_node_deletion(self)
	queue_free()

func _on_RemoteButton_interaction(controller):
	trigger(self)
	pass # Replace with function body.
