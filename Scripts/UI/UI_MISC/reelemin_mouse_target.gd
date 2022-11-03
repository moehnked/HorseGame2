extends Panel


signal emit_mouse_enter(mt)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "emit_mouse_over")
	pass # Replace with function body.

func emit_mouse_over():
	emit_signal("emit_mouse_enter", self)
