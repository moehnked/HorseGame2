extends Sprite

enum Status{GRID, QUEUED, PLAYER, LOADED}

export(Status) var status


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_status(s):
	match s:
		0:
			status = Status.GRID
		1:
			status = Status.QUEUED
		2:
			status = Status.PLAYER
		3:
			status = Status.LOADED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match status:
		Status.GRID:
			modulate = Color(1,1,1,0.2)
		Status.QUEUED:
			modulate = Color(0,1,0,1)
		Status.PLAYER:
			modulate = Color(1,0.5,0.5,1)
		Status.LOADED:
			modulate = Color(0,0,1,0.6)
#	pass
