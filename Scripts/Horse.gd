extends KinematicBody

const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods
const Utils = preload("res://Utils.gd")

onready var challengeResource = preload("res://giddyup_challenge.tscn")
onready var saddle = $Saddle

export var createAngryChildren = false
export var garunteedConversation = false
export var isAggroAtStart = true
export var pep = 0
export var readyToHaveKids = false

var acceleration = 20
var airAcceleration = 1
var bloodlust_rate
var callback
var callback_kargs = {}
var canJump = true
var corral
var currentAnimation = ""
var direction = Vector3()
var enemies = []
var fall = Vector3()
var followThreshold = 20.0
var followingTarget = null
var fullContact = false
var gravity = 25
var gravityVector = Vector3()
var greedRate
var hAcceleration = 6
var hVelocity = Vector3()
var hasBeenInitialized = false
var horseComs = []
var horse_icon = "res://Sprites/UI/Horse_Icon_01.png"
var horse_icon_size = 1
var HP = 10
var impact_dir
var input = InputMacro.new()
var jump = 10
var knockbackDirection = Vector3()
var maxhp = 10
var mouseSensitivity = 0.12
var movement = Vector3()
var normalAcceleration = 6
var personality
var playerRef
var previousInteractionResult = 0
var rootRef
var rng
var scaleFactor = 1.666
var shouldFollowTrainer = true
var speedAdjust = 5
var state = State.idle
var stopFollowThreshold = 4
var temp_rot
var tempTalkBanList = []
var trainer
var turnSpeed = 20
var velocity = Vector3()
var wandering_point = Vector3()

var mood = {
	HorseMoods.heart : 0,
	HorseMoods.diamond : 0,
	HorseMoods.club : 0,
	HorseMoods.spade : 0,
	HorseMoods.greed : 0,
	HorseMoods.bloodlust : 0,
}
var relationships = {}
export var stats = {
	'Speed':1,
	'Width':1,
	'Chaos':1,
	'Silly':1
}

enum State {
	attack,
	dialogue,
	giddyup,
	hors_de_combat,
	idle,
	knockback,
	lasso,
	none,
	pilot,
	running,
	talking,
	walking,
}

var sfx_whinnys = [
	"res://sounds/horse_01.wav",
	"res://sounds/horse_03.wav"
]

var sfx_other = [
	"res://sounds/horse_02.wav"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_rng()
	horse_icon = "res://Sprites/UI/Horse_Icon_0" + String((rng.randi() % horse_icon_size) + 1) + ".png"
	if(!hasBeenInitialized):
		initialize_personality()
	enter_idle_state()
	pass # Replace with function body.

func _on_IdleTimer_timeout():
	if(horseComs.size() > 0):
		find_horse_to_talk_to()
	else:
		start_wandering()

func _on_KnockbackTimer_timeout():
	enter_idle_state()
	pass # Replace with function body.

func _on_WalkTimer_timeout():
	enter_idle_state()

func _physics_process(delta):
	match state:
		State.attack:
			apply_gravity(delta)
			#move_towards(followingTarget, delta)
			pass
		State.idle:
			apply_gravity(delta)
			if(has_trainer() and shouldFollowTrainer):
				look_for(trainer, followThreshold, "start_moving_towards", {'target': trainer, 'thresh': 5, 'callback':"enter_idle_state"})
				pass
			else:
				find_horse_to_talk_to()
			pass
		State.knockback:
			move_based_on_knockback(delta)
			apply_gravity(delta)
		State.lasso:
			pass
		State.pilot:
			print("piloting...")
			rotate_y(input.mouse_horizontal)
			parse_movement(delta)
			move_based_on_input(delta)
		State.running:
			run_towards(followingTarget, delta)
			apply_gravity(delta)
		State.walking:
			walk_towards(followingTarget, delta)
			apply_gravity(delta)
			pass

func add_horse_to_coms(h):
	if(h != self):
		print(name," is adding ", h.name, " to coms...")
		horseComs.append(h)

func apply_gravity(delta):
	if $GroundCheck.is_colliding():
		fullContact = true
	else:
		fullContact = false
	
	if not is_on_floor():
		gravityVector += Vector3.DOWN * gravity * delta
		hAcceleration = airAcceleration
	elif is_on_floor() and fullContact:
		gravityVector = - get_floor_normal() * gravity
		hAcceleration = normalAcceleration
	else:
		gravityVector = - get_floor_normal()
		hAcceleration = normalAcceleration
#
#func apply_gravity(delta):
#	if not is_on_floor():
#		canJump = false
#		fall.y -= gravity * delta
#	else:
#		canJump = true
#
#	move_and_slide(fall, Vector3.UP)

func apply_rotation(input):
	if state == State.pilot:
		rotate_y(input.mouse_horizontal)

func attack():
	set_animation("Attack")
	state = State.none
	$AttackHitboxTimer.start()

func begin_dialogue(other):
	stop_all_timers()
	turn_and_face(other)
	set_animation("Idle")
	state = State.dialogue

func calculate_knockback_vector(hitbox, player):
	return (hitbox.global_transform.origin - player.global_transform.origin) * 10
	pass

func calculate_random_weights():
	var ps = []
	var limit = 0.0
	var rng = RandomNumberGenerator.new()
	for n in range(6):
		var weight = rng.randf()
		ps.append(weight)
		limit += weight
	for n in range(6):
		ps[n] = ps[n] / limit
	return ps

func calculate_speed():
	return stats.Speed * 15

func can_be_charmed():
	return ((pep > -5) and (state != State.attack and state != State.hors_de_combat))

func can_be_lassoed():
	return (pep >= 0) or state == State.hors_de_combat

func can_play_horse():
	return true

func check_if_alive():
	if(HP <= 0):
		queue_free()

func check_relationships(person):
	if relationships.has(person):
		return relationships[person]
	else:
		return 0

func correct_scale():
	scale = Vector3(scaleFactor, scaleFactor, scaleFactor)

func create_horse(other_parent):
	print(name, " had a baby with ", other_parent.name, " ~~ ", owner.name if owner != null else "null")
	var child = load("res://prefabs/Horse.tscn").instance()
	if(!createAngryChildren):
		child.isAggroAtStart = false
	child.initialize(self, other_parent)
	if(rootRef == null):
		rootRef = get_tree().get_root().get_node("World")
	rootRef.add_child(child)
	child.global_transform.origin = other_parent.global_transform.origin + Vector3(rng.randf_range(0.0, 40 * stats.Silly), 0.0, rng.randf_range(0.0, 40*stats.Silly))
	var p = child.get_parent().name if child.get_parent() != null else "null"
	print("~~~ child parent: ", p, " -- child owner: ", child.owner.name if child.owner != null else " null ")
	print("child position: ", child.global_transform.origin, " ~~~ ", other_parent.name,"'s position: ", other_parent.global_transform.origin)

func deal_damage(power):
	HP -= power
	check_if_alive()

func enable_interact():
	$HorseInteractionController.enable_interaction()

func enter_giddyup(rider, root):
	stop_all_timers()
	rootRef = root
	$HorseInteractionController.disable_interaction()
	if (state != State.giddyup):
		if(has_trainer()):
			enter_pilot()
			rider.enter_pilot()
		else:
			playerRef = rider
			state = State.giddyup
			var rootRef = get_tree().get_root().get_node("World")
			var challenge_instance = challengeResource.instance()
			challenge_instance.player_ref = playerRef
			challenge_instance.horse_ref = self
			rootRef.call_deferred("add_child", challenge_instance)

func enter_idle_state():
	state = State.idle
	start_idle_timer()
	set_animation("Idle")

func enter_knockback(vector, dmg):
	knockbackDirection = vector
	state = State.knockback
	$KnockbackTimer.start(0.2 * dmg)

func enter_pilot():
	stop_all_timers()
	playerRef.enter_pilot()
	play_random_sound()
	state = State.pilot
	subscribe_to()
	$HorseInteractionController.disable_interaction()

func enter_talk_state():
	state = State.talking
	stop_all_timers()
	stop_walking()
	turn_and_face(followingTarget)
	previousInteractionResult = $HorseInteractionController.determine_interaction(followingTarget)
	$TalkCooldownTimer.start(2)
	pass

func exit_dialogue():
	start_wandering()

func exit_giddyup():
	enter_idle_state()

func exit_pilot():
	$HorseInteractionController.start_interaction_colldown()
	unsubscribe_to()
	play_random_sound()
	if(has_trainer()):
		look_for(trainer)
	else:
		enter_idle_state()

func find_horse_to_talk_to():
	stop_all_timers()
	for i in horseComs:
		print("is ", name, " allowed to talk to ", i.name," ? ", !tempTalkBanList.has(i))
		var c = rng.randf_range(0.0,1.0) >= 0.5
		if (c or garunteedConversation) and !tempTalkBanList.has(i):
			print("I'm gonna go talk to  ", i.name)
			start_moving_towards({'target':i, 'thresh':6, 'callback':"start_conversation_with_horse"})
			return
	start_wandering()

func get_best_stat():
	var val = 0
	var key = ''
	for k in stats.keys():
		if (stats[k] > val):
			val = stats[k]
			key = k
	return {'key': key, 'value': val}

func get_icon():
	return horse_icon

func get_inventory():
	return $HorseInteractionController.get_inventory()

func get_min_stat_between(a, b):
	return a if (a['value'] < b['value']) else b

func get_palm():
	return $ItemHold

func get_worst_stat():
	var val = 10
	var key = ''
	for k in stats.keys():
		if (stats[k] < val):
			val = stats[k]
			key = k
	return {'key': key, 'value': val}

func get_stat_total():
	return stats.Speed + stats.Chaos + stats.Width + stats.Silly

func get_state():
	return str(State.keys()[state])

func go_to_basket_point(args):
	print("gonna go shoot my shot! at ", args.basket," - ", args.scorePos)
	start_moving_towards({'target':args.scorePos, 'thresh':3.0, 'callback':"target_basket", 'kargs': {'basket':args.basket}})
	pass

func go_to_corral():
	var corrals
	if(rootRef != null):
		corrals = rootRef.get_node("GlobalCorralRegistrar")
	else:
		rootRef = get_tree().get_root().get_node("World")
		corrals = rootRef.get_node("GlobalCorralRegistrar")
	print("travelling to ", corral)
	trainer.exit_pilot(false)
	shouldFollowTrainer = false
	start_moving_towards({'target': corrals.get_corral(), 'thresh': 1.0, 'is_running':true,'callback': "go_to_corral_center"})

func go_to_corral_center():
	start_moving_towards({'target':followingTarget.get_midpoint(), 'callback':'enter_idle_state'})

func has_trainer():
	return trainer != null

func highlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://materials/horse_toon_highlighted.tres"))

func initialize(mom, dad):
	initialize_rng()
	initialize_stats(mom, dad)
	initialize_personality(mom, dad)
	hasBeenInitialized = true

func initialize_personality(mom = null, dad = null):
	if(isAggroAtStart):
		pep = rng.randi_range(-10,5)
	else:
		pep = pep
	var moodboard = [HorseMoods.heart, HorseMoods.diamond, HorseMoods.club, HorseMoods.spade, HorseMoods.greed, HorseMoods.bloodlust]
	personality = calculate_random_weights()
	var mood_vals = [2,1,0,0,-1,-2]
	for n in mood_vals:
		var i = roll_moods(personality)
		set_moods(moodboard, i, mood_vals[n])
	moodboard = [HorseMoods.heart, HorseMoods.diamond, HorseMoods.club, HorseMoods.spade, HorseMoods.greed, HorseMoods.bloodlust]
	if(mom != null):
		var weight = 0.0
		var i = 0
		for m in mom.personality:
			if m > weight:
				weight = m
			i += 1
		set_moods(moodboard, i, 2)
	if(dad != null):
		var weight = 0.0
		var i = 0
		for m in dad.personality:
			if m > weight:
				weight = m
			i += 1
		set_moods(moodboard, i, 2)

func initialize_rng():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func initialize_stats(mom, dad):
	var m_stat = mom.get_best_stat()
	var d_stat = dad.get_best_stat()
	var w_stat = get_min_stat_between(mom.get_worst_stat(), dad.get_worst_stat())
	stats[m_stat['key']] = m_stat['value']
	stats[d_stat['key']] = d_stat['value']
	stats[w_stat['key']] = w_stat['value']
	for k in stats.keys():
		if (m_stat['key'] != k) and (d_stat['key'] != k) and (w_stat['key'] != k):
			stats[k] = rng.randi_range(1,10)

func is_horse():
	return true

func lasso(l):
	state = State.lasso
	impact_dir = l.rotation
	temp_rot = Vector3(rotation.x, rotation.y, rotation.z)

func look_for(target, r = 0, _callback = callback, kargs = {}):
	if report_distance(target) > (followThreshold if (r == 0) else r):
		start_moving_towards({'target':target, 'thresh':stopFollowThreshold, 'callback':_callback, 'is_running':true, 'kargs': kargs})
	else:
		enter_idle_state()
		pass

func move_based_on_input(delta):
	direction = direction.normalized()
	hVelocity = hVelocity.linear_interpolate(direction * 3 * (stats.Speed + speedAdjust), hAcceleration * delta)
	movement.z = hVelocity.z + gravityVector.z
	movement.x = hVelocity.x + gravityVector.x
	movement.y = gravityVector.y
	move_and_slide(movement, Vector3.UP)
	playerRef.rotation.y = rotation.y
	playerRef.global_transform.origin = saddle.global_transform.origin
	if(direction.z != 0.0 and currentAnimation != "Trot"):
		set_animation("Trot", 2)
	elif (direction.z == 0.0 and currentAnimation != "Idle"):
		set_animation("Idle")

func move_based_on_knockback(delta):
	move_and_slide(knockbackDirection, Vector3.UP)
	apply_gravity(delta)

func parse_input(_input):
	input = _input

func parse_movement(delta):
	print("parsing horse")
	direction = Vector3()
	
	if $GroundCheck.is_colliding():
		fullContact = true
	else:
		fullContact = false
	
	if not is_on_floor():
		gravityVector += Vector3.DOWN * gravity * delta
		hAcceleration = airAcceleration
	elif is_on_floor() and fullContact:
		gravityVector = - get_floor_normal() * gravity
		hAcceleration = normalAcceleration
	else:
		gravityVector = - get_floor_normal()
		hAcceleration = normalAcceleration
	
	if input.space and (is_on_floor() or $GroundCheck.is_colliding()):
		gravityVector = Vector3.UP * jump
	
	if input.forward:
		direction -= transform.basis.z
	if input.backward:
		direction += transform.basis.z
	if input.left:
		direction -= transform.basis.x
	if input.right:
		direction += transform.basis.x

func pick_random_spot_nearby():
	if(followingTarget != null):
		if(followingTarget.has_method("is_test_point")):
			followingTarget.queue_free()
			followingTarget = null
	var wander_range = 30
	var x = rand_range(-1,1) * wander_range
	var z = rand_range(-1,1) * wander_range
	var point = Vector3(global_transform.origin.x + x,global_transform.origin.y,global_transform.origin.z + z)
	if(rootRef == null):
		rootRef = Utils.get_world(self)
	return rootRef.create_point(point)

func play_random_sound():
	var sfx = load(sfx_other[randi() % sfx_other.size()])
	update_audio_stream(sfx)

func play_random_whinny():
	var sfx = load(sfx_whinnys[randi() % sfx_whinnys.size()])
	update_audio_stream(sfx)

func recieve_charm(charm, charmer):
	print(name, " RECIEVED CHARM ", charm)
	if(relationships.has(charmer)):
		relationships[charmer] += mood[charm]
	else:
		relationships[charmer] = mood[charm]
	
	if(mood[charm] > 0):
		pep += 1
	elif(mood[charm] < 0):
		pep -= 1
	
	print(name, "'s Relationship with ", charmer.name, " increased by ", mood[charm], " to ", relationships[charmer])
	print("Pep: ", pep)
	match(mood[charm]):
		2:
			$Particles.loved()
		1:
			$Particles.liked()
		0:
			pass
		-1:
			$Particles.disliked()
		-2:
			$Particles.hated()
	if(check_relationships(charmer) < -4):
		#set_attack_target(charmer)
		pass
	return mood[charm]

func report_distance(target):
	return global_transform.origin.distance_to(target.global_transform.origin)

func roll_moods(weights):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var threshold = rng.randf_range(0.0, 1.0)
	var score = 0.0
	var i = 0
	while i < weights.size()-1 and score < threshold:
		score += weights[i]
		i += 1
	return i

func run_towards(target, delta):
	turn_and_face(target)
	#var facing = -global_transform.basis.z * calculate_speed() * 10 * delta
	var facing = -global_transform.basis.z * 10 * (calculate_speed() + speedAdjust) * delta
	move_and_slide(facing)
	if(report_distance(followingTarget) < stopFollowThreshold):
		if(callback != ""):
			call(callback, callback_kargs) if (callback_kargs != null) else call(callback)
		else:
			set_animation("Idle", 0)
			state = State.none

func set_animation(clip = "Idle", s = 1.0):
	currentAnimation = clip
	$full_rig_white2/AnimationPlayer.get_animation(clip).set_loop(true)
	$full_rig_white2/AnimationPlayer.play(clip)
	$full_rig_white2/AnimationPlayer.playback_speed = s * (Utils.logWithBase(stats.Speed, 10) + 1)
	$full_rig_white2/AnimationPlayer.seek(0)

func set_moods(mb, i, v):
	mood[mb[i]] = v
	personality.remove(i)
	mb.remove(i)

func start_conversation_with_horse():
	print("I am now talking to ", followingTarget.name)
	state = State.talking
	stop_walking()
	$HorseInteractionController.determine_interaction(followingTarget)
	$TalkCooldownTimer.start()

func start_playing_horse(ball, basket, scorePos):
	turn_and_face(ball)
	start_moving_towards({'target': ball, 'thresh':5.0, 'callback':'go_to_basket_point', 'kargs': {'basket':basket, 'scorePos': scorePos}})
	pass

func start_moving_towards(args = {}):
	args = Utils.check(args, {'target':null, 'thresh' : stopFollowThreshold, 'callback' : "", 'is_running' : false, 'kargs' : null})
	if(followingTarget != null):
		if(followingTarget.has_method("is_test_point")):
			followingTarget.queue_free()
			followingTarget = null
			pass
	
	if(args.target == self):
		print("! you can't walk towards yourself, you dummy!")
		start_wandering()
	else:
		stop_all_timers()
		followingTarget = args.target
		callback = args.callback
		callback_kargs = args.kargs
		stopFollowThreshold = args.thresh
		start_running() if args.is_running else start_walking()
		print("departing from ", global_transform.origin, " - must travel : ", report_distance(followingTarget))

func start_running():
	print("starting to run to ", followingTarget.name)
	if(followingTarget == trainer):
		stopFollowThreshold = 10
	state = State.running
	set_animation("Trot", 2)

func start_walking():
	print("starting to walk to ", followingTarget.name)
	state = State.walking
	set_animation("Walk")

func start_wandering():
	start_moving_towards({
		'target':pick_random_spot_nearby(), 
		'thresh':rng.randf_range(2.0, 10.0), 
		'callback':"enter_idle_state"}
	)
	pass

func start_idle_timer():
	$IdleTimer.start(rand_range(0.1,4.5))

func stop_all_timers():
	$IdleTimer.stop()
	$WalkTimer.stop()
	$KnockbackTimer.stop()
	$AttackHitboxTimer.stop()
	$AttackCooldownTimer.stop()
	$TalkCooldownTimer.stop()

func stop_talking_to():
	if(followingTarget != null):
		#print(name, " did not enjoy talking to ", followingTarget.name)
		tempTalkBanList.append(followingTarget)
		followingTarget = null
	previousInteractionResult = 0
	start_wandering()

func stop_walking():
	set_animation()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func take_damage(dmg, hitbox, player):
	update_relationship(player, -dmg)
	HP -= dmg
	if(HP <= 0):
		if(trainer != null):
			trainer.remove_from_party(self)
		queue_free()
	else:
		if(has_trainer()):
			trainer.report_damage(self)
		enter_knockback(calculate_knockback_vector(hitbox, player), dmg)
		pass

func tame(tamer):
	stop_all_timers()
	trainer = tamer
	pep += 1
	play_random_whinny()
	if(!trainer.add_to_party(self)):
		print("party full")
		go_to_corral()
	else:
		enter_pilot()

func target_basket(args):
	stop_walking()
	state = State.none
	turn_and_face(args.basket)
	global_transform.origin.x = followingTarget.global_transform.origin.x
	global_transform.origin.z = followingTarget.global_transform.origin.z
	$TargetBasketTimer.start(rng.randf_range(0.5,1.5))

func turn_and_face(target):
	if(target != null):
		var trs = global_transform.looking_at(target.global_transform.origin, Vector3.UP)
		global_transform = trs
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		correct_scale()

func unhighlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://materials/horse_toon.tres"))

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func update_audio_stream(sfx):
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stream = sfx
		$AudioStreamPlayer.play()

func update_relationship(person, value):
	if(relationships.has(person)):
		relationships[person] += value
	else:
		relationships[person] = value

func validate_reproduction(other):
	print("validating reproduction...")
	if self.get_index() < other.get_index():
		create_horse(other)

func walk_towards(other, delta):
	turn_and_face(other)
	#var facing = -global_transform.basis.z * (calculate_speed() + speedAdjust) * delta
	direction = -global_transform.basis.z
	hVelocity = hVelocity.linear_interpolate(direction * 0.2 *(stats.Speed + speedAdjust), hAcceleration * delta)
	movement.z = hVelocity.z + gravityVector.z
	movement.x = hVelocity.x + gravityVector.x
	movement.y = gravityVector.y
	move_and_slide(movement, Vector3.UP)
	if(report_distance(followingTarget) < stopFollowThreshold):
		if(callback != ""):
			call(callback, callback_kargs) if (callback_kargs != null) else call(callback)
		else:
			set_animation("Idle", 0)
			state = State.none
	#playerRef.rotation.y = rotation.y
	#playerRef.global_transform.origin = saddle.global_transform.origin
#	if(direction.z != 0.0 and currentAnimation != "Trot"):
#		set_animation("Trot", 2)
#	elif (direction.z == 0.0 and currentAnimation != "Idle"):
#		set_animation("Idle")

#func walk_towards(other, delta):
#	turn_and_face(other)
#	var facing = -global_transform.basis.z * (calculate_speed() + speedAdjust) * delta
#	move_and_slide(facing)
#	if(report_distance(followingTarget) < stopFollowThreshold):
#		#print("close enough to ", followingTarget.name, " - ", report_distance(followingTarget), " - ", followThreshold)
#		if(callback != ""):
#			call(callback, callback_kargs) if (callback_kargs != null) else call(callback)
#		else:
#			set_animation("Idle", 0)
#			state = State.none

func _on_AggroRange_area_entered(area):
	if pep < -5:
		if area.has_method("aggroable"):
			if (rng.randf_range(0.0, 1.0) < area.aggroable()):
				#set_attack_target(area)
				pass
		elif(area.owner != null):
			if area.owner.has_method("aggroable"):
				if (rng.randf_range(0.0, 1.0) < area.owner.aggroable()):
					#set_attack_target(area.owner)
					pass
	elif(check_relationships(area) < -4):
		#set_attack_target(area)
		pass
	elif(area.owner != null):
		if(check_relationships(area.owner) < -4):
			#set_attack_target(area.owner)
			pass
		elif(area.owner.has_method("is_horse") and !horseComs.has(area.owner)):
			#add to list of horses in range of tlaking
			add_horse_to_coms(area.owner)
			pass
	elif(area.has_method("is_horse") and !horseComs.has(area)):
		#add to list of horses in range of talking
		add_horse_to_coms(area)
		pass
	pass # Replace with function body.


func _on_AttackHitboxTimer_timeout():
	var hitbox = load("res://prefabs/Spells/Punch.tscn").instance()
	$AttackPoint.call("add_child", hitbox)
	hitbox.initialize({'player':self, 'root':rootRef, 'palm':$AttackPoint})
	$AttackCooldownTimer.start()
	pass # Replace with function body.

func _on_AttackCooldownTimer_timeout():
	print("attack done")
	#we need to know if the player is close enough to attack or not
	if(report_distance(followingTarget) > followThreshold / 3):
		#need to move to get to player
		print("chasing target")
		#set_attack_target(followingTarget)
	else:
		#rotate to face player and keep followingTarget
		print("target close enough")
		turn_and_face(followingTarget)
		attack()
		pass
	pass # Replace with function body.

func _on_TalkCooldownTimer_timeout():
	if(state == State.talking and previousInteractionResult != null):
		print(name,"'s previous interaction with ", (followingTarget.name if followingTarget != null else "n??"))
		if(previousInteractionResult < 0):
			followingTarget.stop_talking_to()
			stop_talking_to()
			pass
		else:
			print(name, " had a positive interaction with ", followingTarget)
			enter_talk_state()
	else:
		stop_talking_to()

func _on_AggroRange_area_exited(area):
	if(area.has_method("is_horse")):
		horseComs.erase(area)
	elif(area.owner != null):
		if(area.owner.has_method("is_horse")):
			horseComs.erase(area.owner)
	pass # Replace with function body.

func _on_TempTalkBanTick_timeout():
	tempTalkBanList.pop_front()
	$TempTalkBanTick.start(10)
	pass # Replace with function body.


func _on_TargetBasketTimer_timeout():
	print("time to shoot")
	$HorseInteractionController.throw_equipped()
	state = State.none
	pass # Replace with function body.
