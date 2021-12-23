tool
extends Spatial


export(bool) var isEmitting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isEmitting:
		for c in get_children():
			c.restart()
			c.emitting = true
		isEmitting = false
#	pass
