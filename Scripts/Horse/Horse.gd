#Horse.gd
extends KinematicBody

class_name Horse

const hbRef = preload("res://Scripts/Horse/Behaviors/HorseBehavior.gd")

signal emit_charm_recieved(charm, charmer, spell)
signal emit_highlight(toggle)

export(Array, String) var acceptedItemsToSell = []
export var DEACCEL:int = 6
export var MAX_ACCEL:int = 2
export var MAX_SLOPE_ANGLE:float = 90
export var MAX_SPEED:int= 7
var snapVector = Vector3(0,0,0)
var isSliding = false
export var horseName = "Horse"
export var isInteractingWith = false
export var pep:int = 0
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
var uid = 0

enum Breeds{Appaloosa, Paint, Saddlbred, QuarterHorse,test,Halflinger,Lipizzan}
export(Breeds) var breed = Breeds.test
var breedMaterials = {
	Breeds.test:preload("res://Materials/BreedMaterials/test.tres"),
	Breeds.Paint:preload("res://Materials/BreedMaterials/Paint.tres"),
	Breeds.Saddlbred: preload("res://Materials/BreedMaterials/Saddlebred.tres"),
	Breeds.QuarterHorse: preload("res://Materials/BreedMaterials/QuarterHorse.tres"),
	Breeds.Appaloosa: preload("res://Materials/BreedMaterials/Appaloosa.tres"),
	Breeds.Halflinger: preload("res://Materials/BreedMaterials/Haflinger.tres"),
	Breeds.Lipizzan: preload("res://Materials/BreedMaterials/Lipizzan.tres")

}

var jumpSFX = [
	preload("res://Sounds/jump01.wav"),
	preload("res://Sounds/jump02.wav"),
	preload("res://Sounds/jump03.wav")
]
var rustleSFX = [
	preload("res://Sounds/rustle1.wav"),
	preload("res://Sounds/rustle2.wav"),
	preload("res://Sounds/rustle3.wav"),
	preload("res://Sounds/rustle4.wav"),
]

var squibs = [
	preload("res://prefabs/Items/Meat_A.tscn"),
	preload("res://prefabs/Items/Meat_B.tscn"),
	preload("res://prefabs/Items/Meat_C.tscn"),
	preload("res://prefabs/Items/Meat_D.tscn"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persist")
	initialize_breed()
	initialize_uid()
	initialize_stats()
	pass # Replace with function body.

func add_behavior(HB):
	print("adding behavior: ", HB.stateName)
	var hb = HB.duplicate(7)
	get_state_machine().add_child(hb)
	set_state({"behaviorName":hb.stateName, 
		"callback":"set_state",
		"kargs":{"behaviorName":get_state(), 
		"initialArgs":get_behavior().initialArgs }
		})
	

func apply_gravity(velocity, delta):
	snapVector = Vector3.ZERO
	var n = null
	if get_slide_count() >= 1:
		n = get_slide_collision(0)
	var floor_angle = 0
	if n != null and n.collider != null:
		floor_angle = rad2deg(n.normal.angle_to(Vector3.UP))
		if floor_angle < 75 and n.collider.is_in_group("Stairs"):
			print("FPS: Normal: walking on stairs")
			pass
		elif floor_angle > MAX_SLOPE_ANGLE:
			#print("xwa")
			velocity.y += gravity * delta
			if n.collider.is_in_group("Ground"):
				print("sliding")
				isSliding = true
		else:
			#print("xwb")
			reset_contact()
			snapVector = -n.normal
	elif not get_ground_check().is_colliding():
		has_contact = false
		velocity.y += gravity * delta
	elif is_on_floor():
		#print("xwD")
		reset_contact()
	else:
		#print("xwE")
		reset_contact()
		var raynormal = get_ground_check().get_collision_normal()
		floor_angle = rad2deg(raynormal.angle_to(Vector3.UP))
	return velocity

func attack(args = {}):
	set_state(Utils.check(args, {"behaviorName":"Attack", "state":0}))

func check_item_added(item):
	var hb = item.get_behavior()
	if hb != null:
		add_behavior(hb)

func check_use_item(item):
	var valid_item_uses = [
		"Apple"
	]
	var valid = valid_item_uses.has(item.get_name())
	if valid:
		highlight()
	return valid

func can_be_lassod():
	var non_lassoable_state = ["Dialogue"]
	var state = $StateMachine.get_state()
	return not non_lassoable_state.has(state)

func death():
	if trainer != null:
		trainer.remove_from_party(self)
	get_tree().call_group("GlobalEffectsPool", "queue_horse_death", global_transform.origin+ Vector3(0,2,0))
	for i in range(Utils.get_rng().randi_range(2,6)):
		var obj = Global.world.instantiate(Utils.get_random(squibs), global_transform.origin + Vector3(0,1,0))
		obj.apply_central_impulse(Vector3(Utils.rand_float_range(-5,5),8,Utils.rand_float_range(-5,5)))
	queue_free()

func disable_interaction():
	$Interactable.set_interactable(false, true, true)

func enable_interactability():
	$Interactable.set_interactable(true)
	pass

func enter_idle():
	set_state({"behaviorName":"Idle"})

func enter_pilot():
	set_state({"behaviorName":"Pilot"})

func enter_giddyup(args = {}):
	args = Utils.check(args, {"behaviorName":"Giddyup"})
	set_state(args)
	pass

func enter_RPS(args = {}):
	args = Utils.check(args, {"behaviorName":"RPS"})
	set_state(args)
	pass

func enter_walk_to(args = {}):
	args = Utils.check(args, {"behaviorName":"WalkTo", "target":self, "minDist":2})
	set_state(args)

func exit_command(args):
	print("exiting command ", args)
	match args["ctype"]:
		0:
			args["target"].interact($InteractionController)
			exit_pilot()
	pass

func exit_pilot():
	if trainer == null:
		enter_idle()
	else:
		follow(trainer)

func exit_dialogue():
	print("Horse: exiting dialogue")
	var b = get_behavior()
	var resumeBehaviorArgs = {}
	if "callbackKargs" in b:
		resumeBehaviorArgs = b.callbackKargs["initialArgs"]
		#print("printing CALLBACKKARGS ", resumeBehaviorArgs)
	set_state(resumeBehaviorArgs)
	$Interactable.set_interactable(false)
	Global.world.queue_timer(self, 0.5, "enable_interactability")
	#$StateMachine.currentBehavior.exit()

func follow(target, args = {}):
	set_state(Utils.check({"behaviorName":"Follow", "target":target}, args))

func get_accepted_sell_list():
	return acceptedItemsToSell

func get_animation_controller():
	return $horse_animated

func get_behavior():
	return $StateMachine.currentBehavior
	pass

func get_breed_offset():
	match breed:
		Breeds.Appaloosa:
			return Vector3(0,0,0)
		_:
			return Vector3(randf(),randf(),randf())

func get_equipment_manager():
	return $EquipmentManager

func get_EVRC():
	return get_node("EVRC")

func get_ground_check():
	return $GroundCheck
	
func get_horse_name():
	return horseName

func get_icon():
	return "res://Sprites/UI/Horse_Icon_01.png"

func get_inventory():
	print("Horse: ", get_equipment_manager().name, ": ", get_equipment_manager())
	return get_equipment_manager().get_inventory()

func get_pep():
	return pep

func get_relationship_manager():
	return $RelationshipManager

#func get_saddle():
#	return $Saddle

func get_state():
	return $StateMachine.get_state()
	
func get_state_machine():
	return $StateMachine

func get_stats():
	return stats

func get_trade_scale():
	return stats.poise

func get_trainer():
	return trainer

func get_uid():
	return uid

func go_to_corral():
	var corral = Global.GCR.get_corral()
	enter_walk_to({"target":corral, "callback": "enter_walk_to", "kargs":{"target":corral.get_midpoint(), "callback":"enter_idle"}})

func highlight():
	#$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown_highlighted.tres"))
	emit_signal("emit_highlight", true)
	pass

func initialize_breed():
	get_animation_controller().set_material(breedMaterials[breed])
	get_animation_controller().set_material(get_animation_controller().get_model().get_surface_material(0).duplicate(7))
	get_animation_controller().get_model().get_surface_material(0).uv1_offset += get_breed_offset()

func initialize_stats():
	$Damageable.health = 4 * stats["girth"]
	$Damageable.add_ignore(self)
	$Damageable.connect("destroy", self, "death")
	$Damageable.connect("damageTaken", self, "took_damage")
	pass

func initialize_uid():
	set_uid(Global.GEIDR.generate_uid(self))

func move_at_speed(args = {}):
	args = Utils.check(args, {"dir":Vector3.ZERO, "speed":stats.speed, "velocity":Vector3.ZERO, "delta":0.0, "jump":false,  "directionIsNormalized":false})
	var delta = args.delta
	var velocity = args.velocity
	var direction = args.dir
	var obstDist = 0
	var ratio = 0
	direction.y = 0
	if not args[ "directionIsNormalized"]:
		direction = direction.normalized()
	
	velocity = apply_gravity(velocity, delta)
	
	var h_velocity = velocity
	h_velocity.y = 0
	var movement = direction * (MAX_SPEED - (int(not has_contact) * 2)) * args.speed
	
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
		Global.AudioManager.play_sound(Utils.get_random(jumpSFX), -20 + stats.speed)
		Global.AudioManager.play_sound(Utils.get_random(rustleSFX), -18 + stats.speed)
		velocity.y = 10 * (max(stats.speed / 5.5, 1.0))
		has_contact = false
	
	velocity = move_and_slide_with_snap(velocity, Vector3.ZERO ,Vector3.UP, true, 1, 0.785398, false)
	return {"velocity":velocity, "direction":direction, "position":global_transform.origin}

func recieve_charm(charm, charmer, spell):
	emit_signal("emit_charm_recieved", charm, charmer, spell)

func recieve_command(_target, ctype = 0):
	if _target == self or get_children().has(_target):
		return
	match ctype:
		0:#interactable
			#isInteractingWith = true
			set_state({"behaviorName":"WalkTo", "target":_target, "minDist":2, "isRunning":true, "callback": "exit_command", "kargs":{"ctype":ctype, "target": _target}})
			pass
		1:#attack target
			attack({"target":_target})
			pass

func reset_contact():
	has_contact = true

func rotate_towards_point(point, step = 0.01):
	var old_rot = rotation_degrees
	var trs = global_transform.looking_at(point, Vector3.UP)
	global_transform = trs
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	old_rot = old_rot.linear_interpolate(rotation_degrees, step)
	rotation_degrees = old_rot

func save():
	if trainer != null:
		trainer = trainer.get_uid()
	return Utils.serialize_node(self)

func set(param, val):
	match param:
		"breed":
			.set(param, int(val))
			initialize_breed()
		"trainer":
			if val != null:
				#trainer = Global.GEIDR.get_entity(int(val)) if (val not Global.Player) else val
				if typeof(val) == typeof(Global.Player):
					trainer = val
				else:
					trainer = Global.GEIDR.get_entity(int(val))
		"uid":
			set_uid(int(val))
			Global.GEIDR.register(self)
		_:
			.set(param,val)

func set_pep(val = 0):
	pep = val

func set_state(args = {}):
	args = Utils.check(args, {"behaviorName":"Idle"})
	$StateMachine.set_behavior(args)

func set_uid(_uid):
	uid = _uid

func took_damage(dmg = 1, source = null, damageable = null):
	if source != null:
		rotate_towards_point(source.global_transform.origin, 1.0)
		attack({"target":source, 
					"state":1
					})
	if trainer != null:
		trainer.get_hud().report(self, damageable.health, damageable.MaxHP)
		pass

func tame(args):
	args= Utils.check(args, {"tamer": null, "friendlyFire": false})
	trainer = args.tamer
	if not args["friendlyFire"]:
		for c in get_children():
			if c.is_in_group("Damagable") and trainer != null:
				c.add_ignore(trainer)
	pep += 1
	if(trainer.add_to_party(self)):
		enter_pilot()
		trainer.enter_pilot()
		pass
	else:
		print("party full")
		go_to_corral()
		trainer.exit_pilot(false)

func toggle_collisions(state = true):
	for c in get_children():
		if c is CollisionShape:
			c.disabled = !state

func unhighlight():
	emit_signal("emit_highlight", false)

func use_item(item):
	var methodString = "use_item_" + item.get_name()
	call(methodString, item)

func use_item_Apple(item):
	print("yummy apple")
	item.consume()
	$RelationshipManager.update_relationship(item.get_controller().get_uid(), 10)
	$RelationshipManager.emit_particles(1)
	var s = Utils.get_random(["res://Sounds/eat_01.wav", "res://Sounds/eating_1.wav"])
	Global.AudioManager.play_sound(s)

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Talk"
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	#start dialogue
	set_state({"behaviorName":"Dialogue", "callback":"set_state", "kargs":{"behaviorName":get_state(), "initialArgs":get_behavior().initialArgs }, "talkingToController":controller, "relationship":$RelationshipManager.check_relationships(controller.get_parent())})
	pass # Replace with function body.


func _on_Lassoable_lassoed(by):
	if can_be_lassod():
		if trainer == by:
			$Lassoable.target = self
			$Lassoable.start_pilot()
		else:
			$Lassoable.start_giddyup(self)
	else:
		$Lassoable.stop()
	pass # Replace with function body.

func queue_free():
	if get_state() == "Pilot":
		print("horse died while piloting")
		trainer.call("exit_pilot")
	.queue_free()

func free():
	print("Horse: ", get_horse_name(), " free'd")
	.free()
