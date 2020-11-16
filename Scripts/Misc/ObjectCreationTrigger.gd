extends Spatial

export var objectPath = ""
export var triggerName = ""
export var delay = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if(body.name == triggerName):
		$Timer.start(delay)
	pass # Replace with function body.


func _on_Timer_timeout():
	var obj = load(objectPath).instance()
	owner.add_child(obj)
	queue_free()
	pass # Replace with function body.
