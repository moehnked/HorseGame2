extends Node2D

var nextPos = Vector2(0,0)
var selected = 0
var startingPos

export(NodePath) var display

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = position
	for c in get_children():
		c.connect("emit_focus_entered", self, "update_selection")
	update_selection()
	nextPos = startingPos
	pass # Replace with function body.

func _process(delta):
	position = position.linear_interpolate(nextPos, 0.1)

func update_selection(n = get_child(selected)):
	var c = get_children()
	selected = c.find(n)
	update_alpha(selected, 1, 1)
	update_alpha(selected, 1, -1)
	nextPos.y = startingPos.y - (54 * selected)
	Global.AudioManager.play_sound("res://Sounds/UI_Select_A.wav",1)
	get_node(display).set_texture(n.icon)

func update_alpha(i, a, inc):
	if i < 0 or i >= get_child_count():
		return true
	var o = get_children()[i]
	o.modulate.a = a
	o.set_offset(Vector2(position.x + (17 * abs(selected - i)),o.rect_position.y))
	return update_alpha(i + inc, a - .45, inc)
