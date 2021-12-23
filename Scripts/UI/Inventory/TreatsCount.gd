extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = String(Global.Player.get_treats())
	pass # Replace with function body.

func set_display(val):
	text = String(val)
