extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SpotLight.light_energy = 5 + Global.world.rng.randf_range(-1.0,1.0)
	$SpotLight2.light_energy = 5 + Global.world.rng.randf_range(-1.0,1.0)
	pass
