extends Sprite

export(Array, Texture) var sprites

func randomize_sprite():
	texture = Utils.get_random(sprites)
