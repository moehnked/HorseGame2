extends Spatial

func get_avaliable():
	for c in get_children():
		if c.avaliable:
			return c
	return null

func queue_effect(at):
	var e = get_avaliable()
	if e != null:
		e.initialize(at)
	pass
