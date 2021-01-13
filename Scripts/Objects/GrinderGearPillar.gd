extends Spatial

signal emit_grind(groundUp)
var grinding = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func check_grind(other):
	if other.has_method("take_damage"):
		other.take_damage(100, self, self)
		grinding = other
		return
	var op = other.get_parent()
	if op != null:
		if op.has_method("take_damage"):
			op.take_damage(100, self, self)
			grinding = op
			return

func grind_fossil(fossil):
	var parent = get_parent()
	if parent != null:
		if parent.running:
			emit_signal("emit_grind", fossil)
			return true
		return false

func _on_Grinder_emit_start():
	print("gear pillar: emitting start")
	for o in get_children():
		print(o.name)
		if o.has_method("play"):
			o.play()
	pass # Replace with function body.


func _on_Grinder_emit_stop():
	for o in get_children():
		if o.has_method("stop"):
			o.stop()
	pass # Replace with function body.


func _on_Area_area_entered(area):
	check_grind(area)
	pass # Replace with function body.
