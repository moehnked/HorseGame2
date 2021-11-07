extends Spatial

export var rang = 5
export(float,0.0,100) var energy = 1
export(bool) var lightEnabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$OmniLight.visible = lightEnabled
	$OmniLight.light_energy = energy
	$OmniLight.omni_range = rang
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass