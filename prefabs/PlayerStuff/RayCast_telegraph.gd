extends RayCast

signal broadcast_self(raycast)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("broadcast_self", self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
