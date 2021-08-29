extends Area

export(Resource) var eventObject
export(NodePath) var eventInstance
export(bool) var isInstancingEvent = true
export(bool) var killOnTrigger = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func activate(eo):
	eo.call("trigger", self)
	if killOnTrigger:
		queue_free()

func instantiate():
	var eo = eventObject.instance()
	print("Activating generic event: ", eo.name)
	Global.world.place(eo)
	return eo

func target_triggered():
	if isInstancingEvent:
			activate(instantiate())
	else:
		activate(get_node(eventInstance))

func on_area_triggered(body):
	if body == Global.Player:
		target_triggered()

func _on_GenericEventTrigger_body_entered(body):
	on_area_triggered(body)
	pass # Replace with function body.
