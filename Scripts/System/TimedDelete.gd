extends Spatial

export var time = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	Global.world.queue_timer(self, time, "queue_free")
	pass # Replace with function body.

