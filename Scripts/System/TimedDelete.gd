extends Spatial

export var time = 3.5

signal timeout()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Particles:
			i.emitting = true
	var timer = Timer.new()
	timer.connect("timeout",self,"timer_timeout") 
	add_child(timer) #to process
	timer.start(time) #to start

func timer_timeout():
	emit_signal("timeout")
	queue_free()
