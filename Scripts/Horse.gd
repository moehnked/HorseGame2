extends KinematicBody

const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

onready var saddle = $Saddle

export var createAngryChildren = false
export var DEACCEL = 6
export var garunteedConversation = false
export var isAggroAtStart = true
export var MAX_ACCEL = 2
export var MAX_SLOPE_ANGLE = 90
export var pep = 0
export var readyToHaveKids = false

var bloodlust_rate
var callback = ""
var callback_kargs = {}
var canJump = true
var corral
var currentAnimation = ""
onready var currentBehavior = get_node("StateContainer/Idle")
var enemies = []
var fall = Vector3()
var followThreshold = 20.0
var followingTarget = null
var fullContact = false
var gravity = -15
var gravityVector = Vector3()
var greedRate
var hasBeenInitialized = false
var has_contact = false
var horseComs = []
var horse_icon = "res://Sprites/UI/Horse_Icon_01.png"
var horse_icon_size = 1
var HP = 10
var impact_dir
var input = InputMacro.new()
var jump = 10
var keepFollowing = false
var knockbackDirection = Vector3()
var maxhp = 10
var mouseSensitivity = 0.12
var normalAcceleration = 6
var personality
var playerRef
var previousInteractionResult = 0
var rng
var scaleFactor = 0.8
var shouldFollowTrainer = true
var speedAdjust = 5
#var state = State.idle
var stopFollowThreshold = 8
var temp_rot
var tempTalkBanList = []
var trainer = null
var turnSpeed = 20
var velocity:Vector3 = Vector3()
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

#enum State {
#	attack,
#	dialogue,
#	giddyup,
#	hors_de_combat,
#	idle,
#	knockback,
#	lasso,
#	none,
#	pilot,
#	running,
#	talking,
#	walking,
#}

var sfx_whinnys = [
	"res://sounds/horse_01.wav",
	"res://sounds/horse_03.wav"
]

var sfx_other = [
	"res://sounds/horse_02.wav"
]

func _ready():
	print("state from currentBehavior: ",get_state())
	initialize_rng()
	horse_icon = "res://Sprites/UI/Horse_Icon_0" + String((rng.randi() % horse_icon_size) + 1) + ".png"
	if(!hasBeenInitialized):
		initialize_personality()
	enter_idle_state()

func _on_IdleTimer_timeout():
	print("idle time")
	if(horseComs.size() > 0):
		find_horse_to_talk_to()
	else:
		start_wandering()

func _on_KnockbackTimer_timeout():
	enter_idle_state()

func _on_WalkTimer_timeout():
	enter_idle_state()

func _physics_process(delta):
	apply_gravity(delta)
	currentBehavior.run_state(self, delta)

func add_horse_to_coms(h):
	if(h != self):
		print(name," is adding ", h.name, " to coms...")
		horseComs.append(h)

func apply_gravity(delta):
	if is_on_floor():
		has_contact = true
		var n = $GroundCheck.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3.UP)))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if not $GroundCheck.is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if has_contact and !is_on_floor():
		move_and_collide(Vector3(0,-1,0))

func apply_rotation(input):
	if currentBehavior == $StateContainer/Pilot:
		rotate_y(input.mouse_horizontal)

func attack(args={}):
	set_animation("Attack")
	set_behavior("None")
	if args.has("attack_target"):
		followingTarget = args.attack_target
	$AttackHitboxTimer.start()

func begin_dialogue(other):
	print("starting dialogue")
	set_behavior("Dialogue", {"other": other})

func calculate_knockback_vector(hitbox, player):
	return (hitbox.global_transform.origin - player.global_transform.origin) * 10

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
	var state = get_state()
	return ((pep > -5) and (state != "Attack" or state != "HorsDeCombat"))

func can_be_lassoed():
	var state = get_state()
	return (pep >= 0) or state == "HorsDeCombat"

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
	Global.world.add_child(child)
	child.global_transform.origin = other_parent.global_transform.origin + Vector3(rng.randf_range(0.0, 40 * stats.Silly), 0.0, rng.randf_range(0.0, 40*stats.Silly))
	var p = child.get_parent().name if child.get_parent() != null else "null"
	print("~~~ child parent: ", p, " -- child owner: ", child.owner.name if child.owner != null else " null ")
	print("child position: ", child.global_transform.origin, " ~~~ ", other_parent.name,"'s position: ", other_parent.global_transform.origin)

func deal_damage(power):
	HP -= power
	check_if_alive()

func enable_interact():
	$HorseInteractionController.enable_interaction()

func enter_giddyup(rider):
	set_behavior("Giddyup", {"rider": rider})

func enter_idle_state():
	set_behavior("Idle", {"shouldFollowTrainer":shouldFollowTrainer, "actor": self})

func enter_knockback(vector, dmg):
	set_behavior("Knockback", {"vector": vector, "dmg": dmg})

func enter_pilot():
	set_behavior("Pilot")

func enter_talk_state():
	set_behavior("Talking", {"method":"enter_talk_state"})

func exit_dialogue():
	if not has_trainer():
		start_wandering()
	else:
		enter_idle_state()

func exit_giddyup():
	enter_idle_state()

func exit_pilot():
	$HorseInteractionController.start_interaction_colldown()
	unsubscribe_to()
	play_random_sound()
	if(has_trainer()):
		keepFollowing = true
		look_for({'target':trainer, 'callback':""})
	else:
		enter_idle_state()

func find_horse_to_talk_to():
	stop_all_timers()
	for i in horseComs:
		print("is ", name, " allowed to talk to ", i.name," ? ", !tempTalkBanList.has(i))
		var c = rng.randf_range(0.0,1.0) >= 0.5
		if (c or garunteedConversation) and !tempTalkBanList.has(i):
			print("I'm gonna go talk to  ", i.name)
			start_moving_towards({
				'target':i, 
				'thresh':6, 
				'callback':"start_conversation_with_horse"})
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

func get_interaction_controller():
	return $HorseInteractionController

func get_inventory():
	return $HorseInteractionController.get_inventory()

func get_min_stat_between(a, b):
	return a if (a['value'] < b['value']) else b

func get_palm():
	return $ItemHold

func get_trainer():
	if trainer != null:
		return trainer
	return pick_random_spot_nearby()

func get_worst_stat():
	var val = 10
	var key = ''
	for k in stats.keys():
		if (stats[k] < val):
			val = stats[k]
			key = k
	return {'key': key, 'value': val}

func get_saddle():
	return $Saddle

func get_stat_total():
	return stats.Speed + stats.Chaos + stats.Width + stats.Silly

func get_state():
	return currentBehavior.name

func go_to_basket_point(args):
	print("gonna go shoot my shot! at ", args.basket," - ", args.scorePos)
	start_moving_towards({
		'target':args.scorePos, 
		'thresh':3.0, 
		'callback':"target_basket", 
		'kargs': {'basket':args.basket}})
	pass

func go_to_corral():
	var corrals = Global.GCR
	print("travelling to ", corral)
	trainer.exit_pilot(false)
	shouldFollowTrainer = false
	start_moving_towards({
		'target': corrals.get_corral(), 
		'thresh': 1.0, 
		'is_running':true,
		'callback': "go_to_corral_center"})

func go_to_corral_center():
	start_moving_towards({
		'target':followingTarget.get_midpoint(), 
		'callback':'enter_idle_state'})

func has_trainer():
	return trainer != null

func highlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown_highlighted.tres"))

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
	#state = State.lasso
	set_behavior("Lasso")
	impact_dir = l.rotation
	temp_rot = Vector3(rotation.x, rotation.y, rotation.z)

func look_for(args = {}):
	args = Utils.check(args, {'target':null, 'r':stopFollowThreshold, 'callback':callback, 'kargs':callback_kargs})
	print("looking for ", args.target, " - callback ", args.callback)
	if report_distance(args.target) > args.r:
		start_moving_towards({
			'target':args.target, 
			'thresh':stopFollowThreshold, 
			'callback':args.callback, 
			'is_running':true, 
			'kargs':args.kargs})
	else:
		enter_idle_state()
		pass

func parse_input(_input):
	input = _input

func pick_random_spot_nearby():
	if(followingTarget != null):
		if(followingTarget.has_method("is_test_point")):
			followingTarget.queue_free()
			followingTarget = null
	var wander_range = 30
	var x = rand_range(-1,1) * wander_range
	var z = rand_range(-1,1) * wander_range
	var point = Vector3(global_transform.origin.x + x,global_transform.origin.y,global_transform.origin.z + z)
	return Global.world.create_point(point)

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
		set_attack_target(charmer)
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

func set_animation(clip = "Idle", s = 1.0):
	if currentAnimation != clip:
		currentAnimation = clip
		$full_rig_white2/AnimationPlayer.get_animation(clip).set_loop(true)
		$full_rig_white2/AnimationPlayer.play(clip)
		$full_rig_white2/AnimationPlayer.playback_speed = s * (Utils.logWithBase(stats.Speed, 10) + 1)
		$full_rig_white2/AnimationPlayer.seek(0)

func set_attack_target(target):
	callback = "attack"
	start_moving_towards({
		"target":target,
		"is_running":true,
		"callback":callback,
		'thresh': 4,
		"kargs": {'attack_target': target}
	})

func set_behavior(statename, initargs = {}):
	initargs = Utils.check(initargs, {"actor":self})
	currentBehavior = get_node("StateContainer/" + statename)
	currentBehavior.initialize(initargs)

func set_moods(mb, i, v):
	mood[mb[i]] = v
	personality.remove(i)
	mb.remove(i)

func start_conversation_with_horse():
	set_behavior("Talking", {"method":"start_conversation"})

func start_knockback_timer(time):
	$KnockbackTimer.start(time)

func start_playing_horse(ball, basket, scorePos):
	turn_and_face(ball)
	start_moving_towards({
		'target': ball, 
		'thresh':5.0, 
		'callback':'go_to_basket_point', 
		'kargs': {'basket':basket, 'scorePos': scorePos}})
	pass

func start_moving_towards(args = {}):
	set_behavior("Moving", args)

func start_wandering():
	start_moving_towards({
		'target':pick_random_spot_nearby(), 
		'thresh':rng.randf_range(5.0, 10.0), 
		'callback':"enter_idle_state"}
	)
	pass

func start_idle_timer():
	$IdleTimer.start(rand_range(0.1,4.5))

func start_timer_talk_cooldown(time):
	$TalkCooldownTimer.start(time)

func stop_all_timers():
	$IdleTimer.stop()
	$WalkTimer.stop()
	$KnockbackTimer.stop()
	$AttackHitboxTimer.stop()
	$AttackCooldownTimer.stop()
	$TalkCooldownTimer.stop()

func stop_talking_to():
	if(followingTarget != null):
		tempTalkBanList.append(followingTarget)
		followingTarget = null
	previousInteractionResult = 0
	start_wandering()

func stop_walking():
	set_animation()

func subscribe_to():
	Global.InputObserver.subscribe(self)

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
	#state = State.none
	set_behavior("None")
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
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://Materials/horse_material_light_brown.tres"))

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

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

func _on_AttackHitboxTimer_timeout():
	var hitbox = load("res://prefabs/Spells/Punch.tscn").instance()
	$AttackPoint.call("add_child", hitbox)
	hitbox.initialize({'player':self, 'palm':$AttackPoint})
	$AttackCooldownTimer.start()

func _on_AttackCooldownTimer_timeout():
	print("attack done")
	#we need to know if the player is close enough to attack or not
	if(report_distance(followingTarget) > followThreshold / 3):
		#need to move to get to player
		print("chasing target")
		set_attack_target(followingTarget)
	else:
		#rotate to face player and keep followingTarget
		print("target close enough")
		turn_and_face(followingTarget)
		attack()
		pass
	pass # Replace with function body.

func _on_TalkCooldownTimer_timeout():
	if(get_state() == "Talking" and previousInteractionResult != null):
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
	#state = State.none
	set_behavior("None")
	pass # Replace with function body.
