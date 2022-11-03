extends AnimatedSprite


func randomize_sprite():
	frame = Utils.get_rng().randi_range(0,4)

func get_score():
	return frame + 1
