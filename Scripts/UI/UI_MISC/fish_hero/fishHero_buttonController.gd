extends Sprite

signal missed_hit()
signal successful_hit()
signal emit_pressed(pos)

#export(String, "FishHero_A","FishHero_B","FishHero_X","FishHero_Y") var input
export(String) var input = "FishHero_A"

var hitNote = false

func _input(event):
	if event.is_action_released(input):
		hitNote = false
		emit_signal("emit_pressed", position)
		get_node("AnimationPlayer").play("buttonHit")
		#update fish flop icon

func button_hit_timeout():
	if not hitNote:
		emit_signal("missed_hit")
	hitNote = false

func _on_Area2D_area_entered(area):
	hitNote = true
	emit_signal("successful_hit")
	area.queue_free()
	pass # Replace with function body.
