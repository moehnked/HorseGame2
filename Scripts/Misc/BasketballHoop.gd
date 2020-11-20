extends StaticBody
onready var effect = preload("res://prefabs/Effects/score.tscn")
onready var HORSE = preload("res://prefabs/HORSE_challenge.tscn")
const Utils = preload("res://Utils.gd")

var active = true
var scoreboard = {}
var score_point = null

func get_letter(scorer):
	if(scoreboard.has(scorer)):
		match(scoreboard[scorer]):
			1:
				return "H"
			2:
				return "O"
			3:
				return "R"
			4:
				return "S"
			5:
				return "E"

func get_score_point():
	return score_point

func is_hoop():
	return true

func increment_score(key):
	if scoreboard.has(key):
		scoreboard[key] += 1
	else:
		scoreboard[key] = 1

func set_score(key, val):
	scoreboard[key] = val

func _on_goal_body_entered(body):
	var bi = body.get_node("Item")
	if(bi != null && active):
		print("SCORE!")
		body.linear_velocity = Vector3()
		body.global_transform.origin = $Ring_Point.global_transform.origin
		
		$Ring.disabled = true
		$goal/CollisionShape.disabled = true
		active = false
		$Score_reset.start()
		var e = effect.instance()
		e.global_transform.origin = $Ring_Point.global_transform.origin
		owner.call_deferred("add_child", e)
		var hc = HORSE.instance()
		hc.global_transform.origin = global_transform.origin
		add_child(hc)
		score_point = Utils.get_world(self).create_point(bi.shoot_position)
		if bi.has_method("set_basket"):
			bi.set_basket(self)
		if bi.has_method("get_shooter"):
			var shooter = bi.get_shooter()
			increment_score(shooter.name)
			bi.made_shot()
			if(shooter.has_method("initializeHUD")):
				shooter.initializeHUD(get_letter(shooter.name))
	pass # Replace with function body.


func _on_Score_reset_timeout():
	$Ring.disabled = false
	$goal/CollisionShape.disabled = false
	active = true
	pass # Replace with function body.
