extends Node2D

signal emit_failure()
signal emit_success()

var action_queue = []
var fishLevel = 1
var rodPower = 1
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func attempt_hit(pos = Vector2.ZERO, target = $FishSprite, inverted = false):
	var roll = rng.randf_range(0,1)
	var hc = get_hit_chance(inverted)
	if roll > hc:
		print(roll, " - hit success! against ", hc)
		target.get_child(0).play("Hurt")
	else:
		print(roll, " - failed hit against ", hc)
		$Effects/Miss/AnimationPlayer.play("default")
	$Effects.position = pos + Vector2(0, -40)

func check_actionable():
	if action_queue.size() > 0 and $FishSprite/AnimationPlayer.current_animation == "Idle" and $Bobbler/BobblerAnimationController.current_animation == "Idle" and $Hooksan/HooksanAnimationController.current_animation == "Idle":
		callv("parse_action_selected", action_queue.pop_front())
		pass
	pass

func fish_action():
	#$FishSprite/AnimationPlayer.play("Attack")
	queue_action(0, $FishSprite, $FishTurnTimer)
	pass

func fish_attack():
	#pick random target
	var _target = $Hooksan if rng.randf_range(0.0,1.0) < 5.0 else $Bobbler
	attempt_hit(_target.position, _target, true)
	pass

func get_hit_chance(inverted = false):
	var cx = fishLevel if inverted else rodPower
	var cy = rodPower if inverted else fishLevel
	return 0.45 + ((cx / 18.0) - (cy / 24.0))

func initialize(_fishLevel, _rodPower):
	fishLevel = _fishLevel
	rodPower = _rodPower

func parse_action_selected(actionIDX, _target, _timer):
	var target = _target
	var ap = target.get_child(0)
	match actionIDX:
		0: #Attack
			ap.seek(0)
			ap.play("Attack")
		3: #Pass
			_timer.start_timer()
	pass

func queue_action(actionIDX, _target, _timer):
	action_queue.append([actionIDX, _target, _timer])
	pass


func _on_actionTick_timeout():
	check_actionable()
	pass # Replace with function body.
