#Horse.gd
extends KinematicBody

signal emit_charm_recieved(charm, charmer, spell)
signal emit_highlight(toggle)

export var DEACCEL:int = 6
export var MAX_ACCEL:int = 2
export var MAX_SLOPE_ANGLE:float = 90
export var MAX_SPEED:int= 7
export var horseName = "Horse"
export var stats:Dictionary = {
	"speed":1,
	"chaos":1,
	"silly":1,
	"poise":1,
	"range":1,
	"girth":1
}

var has_contact:bool = false
var gravity = -20
var trainer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_gravity(velocity, delta):
	if is_on_floor():
		has_contact = true
		var n = get_ground_check().get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3.UP)))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if not get_ground_check().is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if has_contact and !is_on_floor():
		move_and_collide(Vector3(0,-2,0))
	return velocity

func can_be_lassod():
	var non_lassoable_state = []
	var state = $StateMachine.get_state()
	return not non_lassoable_state.has(state)

func enter_idle():
	set_state({"behaviorName":"Idle"})

func enter_pilot():
	set_state({"behaviorName":"Pilot"})

func enter_giddyup():
	set_state({"behaviorName":"Giddyup"})
	pass

func enter_walk_to(args = {}):
	args = Utils.check(args, {"behaviorName":"WalkTo", "target":self})
	set_state(args)

func exit_pilot():
	set_state({"behaviorName":"Follow", "target":trainer})

func exit_dialogue():
	var resumeBehaviorArgs = get_behavior().callbackKargs.initialArgs
	set_state(resumeBehaviorArgs)
	#$StateMachine.currentBehavior.exit()

func get_animation_controller():
	return $horse_animated

func get_behavior():
	return $StateMachine.currentBehavior
	pass

func get_equipment_manager():
	return $EquipmentManager

func get_ground_check():
	return $GroundCheck

func get_horse_name():
	return horseName

func get_icon():
	return "res://Sprites/UI/Horse_Icon_01.png"

func get_inventory():
	#return []
	return get_equipment_manager().get_inventory()

func get_relationship_manager():
	return $RelationshipManager

func get_saddle():
	return $Saddle

func get_state():
	return $StateMachine.get_state()

func go_to_corral():
	var corral = Global.GCR.get_corral()
	enter_walk_to({"target":corral, "callback": "enter_walk_to", "kargs":{"target":corral.get_midpoint(), "callback":"enter_idle"}})

func highlight():
	#$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown_highlighted.tres"))
	emit_signal("emit_highlight", true)
	pass

func lasso(lasso):
	print(name, ": 'I'm being lasso'd by", lasso.playerRef.name ,"!'")
	if trainer != null:
		enter_pilot()
		trainer.enter_pilot()
		pass
	else:
		enter_giddyup()

func move_at_speed(args = {}):
	args = Utils.check(args, {"dir":Vector3(), "speed":stats.speed, "velocity":Vector3(), "delta":0.0, "jump":false})
	var delta = args.delta
	var velocity = args.velocity
	var direction = args.dir
	direction.y = 0
	direction = direction.normalized()
	
	velocity = apply_gravity(velocity, delta)
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * MAX_SPEED * args.speed
	
	var acceleration
	if direction.dot(h_velocity) > 0:
		acceleration = MAX_ACCEL
	else:
		acceleration = DEACCEL
		
	h_velocity = h_velocity.linear_interpolate(movement, acceleration * delta)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if args.jump and is_on_floor():
		print("jumping")
		velocity.y = 10 * (min(stats.speed / 2.5, 1.0))
		has_contact = false
	
	velocity = move_and_slide(velocity, Vector3.UP)
	return {"velocity":velocity, "direction":direction, "position":global_transform.origin}

func recieve_charm(charm, charmer, spell):
	emit_signal("emit_charm_recieved", charm, charmer, spell)

func rotate_towards_point(point, step = 0.01):
	var old_rot = rotation_degrees
	var trs = global_transform.looking_at(point, Vector3.UP)
	global_transform = trs
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	#rotation_degrees.y += 180
	old_rot = old_rot.linear_interpolate(rotation_degrees, step)
	rotation_degrees = old_rot

func set_state(args = {}):
	args = Utils.check(args, {"behaviorName":"Idle"})
	$StateMachine.set_behavior(args)

func tame(args):
	args= Utils.check(args, {"tamer": null})
	trainer = args.tamer
	#pep += 1
	#play_random_whinny()
	if(trainer.add_to_party(self)):
		enter_pilot()
		trainer.enter_pilot()
		pass
	else:
		print("party full")
		go_to_corral()
		trainer.exit_pilot(false)

func unhighlight():
	emit_signal("emit_highlight", false)


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Talk"
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	#start dialogue
	set_state({"behaviorName":"Dialogue", "callback":"set_state", "kargs":{"behaviorName":get_state(), "initialArgs":get_behavior().initialArgs }, "talkingToController":controller, "relationship":$RelationshipManager.check_relationships(controller.get_parent())})
	pass # Replace with function body.
