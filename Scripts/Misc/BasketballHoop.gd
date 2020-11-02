extends StaticBody
var active = true
onready var effect = preload("res://prefabs/Effects/score.tscn")


func _on_goal_body_entered(body):
	if(body.get_node("Item") != null && active):
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
	pass # Replace with function body.


func _on_Score_reset_timeout():
	$Ring.disabled = false
	$goal/CollisionShape.disabled = false
	active = true
	pass # Replace with function body.
