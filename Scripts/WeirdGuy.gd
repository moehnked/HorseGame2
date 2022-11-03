extends "res://Scripts/NPC_Base.gd"

var playerRef = null
var lookWeight = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerRef != null:
		var prevDeg = $Skull.rotation_degrees
		$Skull.look_at_from_position($Skull.global_transform.origin, playerRef.global_transform.origin, Vector3.UP)
		$Skull.rotation_degrees = prevDeg.linear_interpolate($Skull.rotation_degrees, lookWeight)
		pass#
	else:
		$Skull.rotation_degrees = $Skull.rotation_degrees.linear_interpolate(Vector3.ZERO, lookWeight)

func exit_dialogue():
	.exit_dialogue()
	$InteractionCooldown.start()
	

func stop_looking():
	playerRef = null

func get_player_ref():
	playerRef = Global.Player

func _on_EventTriggerOnContact_body_exited(body):
	if body == playerRef:
		stop_looking()
	pass # Replace with function body.


func _on_InteractionCooldown_timeout():
	$Interactable.set_interactable(true, true)
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	$Interactable.set_interactable(false, true, true)
	pass # Replace with function body.
