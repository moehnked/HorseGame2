extends Area

var playerRef
var rootRef
var power = 1

func initialize(player, root, palm, callback, hand):
	playerRef = player
	rootRef = root
	$TimeToLive.start()
	global_transform.origin = palm.global_transform.origin
	playerRef.call(callback)

func _on_TimeToLive_timeout():
	queue_free()


func _on_Punch_area_entered(area):
	if(area.has_method("take_damage") && area != playerRef):
		print("punch hitbox hit: ", area)
		area.take_damage(power, playerRef)
	pass # Replace with function body.


func _on_Punch_body_entered(body):
	if(body.has_method("take_damage") && body != playerRef):
		print("punch hitbox hit: ", body)
		body.take_damage(power, self, playerRef)
	pass # Replace with function body.
