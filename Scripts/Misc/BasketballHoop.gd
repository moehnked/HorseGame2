extends StaticBody
onready var effect = preload("res://prefabs/Effects/score.tscn")
onready var HORSE = preload("res://prefabs/HORSE_challenge.tscn")
const Utils = preload("res://Utils.gd")

var active = true
var scoreboard = {}
var scorePoint = null

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
	if(scorePoint == null):
		print("basket is returning a null scorepoint")
	return scorePoint

func is_hoop():
	return true

func increment_score(key):
	if scoreboard.has(key):
		scoreboard[key] += 1
	else:
		scoreboard[key] = 1

func set_score(key, val):
	scoreboard[key] = val

func set_score_point(point, setter = null):
	if(point == null):
		print("set score point to null by ", setter)
	scorePoint = point

func _on_goal_body_entered(body):
	if active and body.has_method("set_basket"):
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
		set_score_point(Utils.get_world(self).create_point(body.thrownFrom))
		hc.set_score_pos(scorePoint)
		if body.has_method("set_basket"):
			body.set_basket(self)
		if body.has_method("get_shooter"):
			var shooter = body.get_shooter()
			increment_score(shooter.name)
			#body.made_shot()
			if(shooter.has_method("initializeHUD")):
				shooter.initializeHUD(get_letter(shooter.name))
	pass # Replace with function body.


func _on_Score_reset_timeout():
	$Ring.disabled = false
	$goal/CollisionShape.disabled = false
	active = true
	pass # Replace with function body.
