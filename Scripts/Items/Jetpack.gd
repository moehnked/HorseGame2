extends "res://Scripts/Items/Equipable.gd"

export(float) var MAX_VEL = 0.5
var vel = 0.1

func _process(delta):
	if isEquipped:
		$AudioStreamPlayer.volume_db = -10 + Utils.vol2db(Global.AudioManager.sfxVolume)
		visible = false
		if Input.is_action_just_pressed("jump"):
			$AudioStreamPlayer.play()
			$PlaySound.trigger()
		if Input.is_action_pressed("jump"):
			vel = lerp(vel, MAX_VEL, 0.1)
			if controller != null:
				var p = controller.get_parent()
				if p != null:
					p.MAX_SPEED = 37
					if p.has_method("get_velocity"):
						p.set_velocity(p.get_velocity() + Vector3(0,vel,0))
						
		elif Input.is_action_just_released("jump"):
			$AudioStreamPlayer.stop()
			$stopsound.trigger()
			if controller != null:
				var p = controller.get_parent()
				if p != null:
					p.MAX_SPEED = 7
	else:
		visible = true
	._process(delta)

