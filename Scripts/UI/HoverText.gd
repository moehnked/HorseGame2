extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = Utils.transform_mouse(get_global_mouse_position())
	position = get_global_mouse_position()

func clear():
	$Label.text = ""

func set_text(txt):
	$Label.text = txt