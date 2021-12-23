extends Spatial


var isRippling
signal emit_effect_end(effect)

func _process(delta):
	if isRippling:
		if not $Particles.emitting:
			print("ripple end")
			isRippling = false
			emit_signal("emit_effect_end",self)

func start():
	$Particles.emitting = true
	isRippling = true
