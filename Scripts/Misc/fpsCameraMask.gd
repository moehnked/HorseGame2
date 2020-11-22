extends Area

func get_head():
	return owner.get_head()

func start_swimming():
	get_head().set_mask(Color(0, 0.80, 0.93, 0.32))

func stop_swimming():
	get_head().set_mask(Color(1,1,1,0))

