extends StaticBody
const Utils = preload("res://Utils.gd")

var active = true
var score_point = null
onready var effect = preload("res://prefabs/Effects/score.tscn")
onready var HORSE = preload("res://prefabs/HORSE_challenge.tscn")

func get_score_point():
	return score_point

func is_hoop():
	return true

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
	pass # Replace with function body.


func _on_Score_reset_timeout():
	$Ring.disabled = false
	$goal/CollisionShape.disabled = false
	active = true
	pass # Replace with function body.
