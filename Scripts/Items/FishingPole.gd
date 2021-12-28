extends "res://Scripts/Items/Equipable.gd"

var bobbleRef = preload("res://prefabs/Objects/Bobble.tscn")
var bobble
var channel
var castPower = 0.0
var isCharging = false
var needsReset = false
var canCast = true

func unequip(args = {}):
	if canUnequip:
		if bobble != null:
			bobble.queue_free()
		castPower = 0.0
		isCharging = false
		needsReset = false
		.unequip(args)
	pass

func cast():
	channel.stop()
	visible = true
	isCharging = false
	var hRef = get_caster().get_hand()
	hRef.apply_texture("Fishing")
	hRef.play_animation("Fishing_Cast")
	channel = Global.AudioManager.play_sound("res://Sounds/fishingCast.wav")
	$AnimationPlayer.play("Cast")
	bobble = Global.world.instantiate(bobbleRef, $fishingpole/Cylinder002/castPoint.global_transform.origin)
	bobble.initialize(self)
	bobble.apply_central_impulse(-Global.Player.global_transform.basis.z * (1 + castPower))
	canCast = false

func get_caster():
	return controller.get_parent()

func retrieve_bobble():
	get_caster().subscribe_to()
	

func start_charge():
	needsReset = true
	isCharging = true
	visible = false
	controller.get_parent().get_hand().update_hand_sprite("Fishing_Charge")
	channel = Global.AudioManager.play_sound("res://Sounds/buildup3.wav")
	$Timer.start()

func _on_Fishing_Pole_emit_held():
	if not isCharging and canCast:
		if not needsReset:
			start_charge()
	else:
		castPower += 0.11
	pass # Replace with function body.


func _on_Fishing_Pole_emit_use():
	if isCharging:
		cast()
	needsReset = false
	castPower = 0.0
	pass # Replace with function body.


func _on_Timer_timeout():
	if isCharging:
		cast()
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Cast":
			var hRef = controller.get_parent().get_hand()
			hRef.play_animation("Fishing")
	pass # Replace with function body.
