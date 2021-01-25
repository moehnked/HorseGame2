extends Spatial

export var time = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Particles:
			i.emitting = true
#	$Particles.emitting = true
#	$Particles2.emitting = true
#	$Particles3.emitting = true
#	Global.world.queue_timer(self, time, "queue_free")
	var timer = Timer.new()
	timer.connect("timeout",self,"timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start(3.0) #to start
	pass # Replace with function body.

func timer_timeout():
	queue_free()
