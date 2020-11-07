extends KinematicBody
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

onready var challengeResource = preload("res://giddyup_challenge.tscn")
onready var saddle = $Saddle

export var isAggroAtStart = true

var attacking
var acceleration = 20
var bloodlust_rate
var canJump = true
var corral
var direction = Vector3()
var fall = Vector3()
var followThreshold = 20.0
var gravity = 11.2
var greed_rate
var health = 10
var HP = 10
var impact_dir
var jump = 10
var knockback_direction = Vector3()
var maxhp = 10
var mouseSensitivity = 0.2
var pep = 0
var personality
var playerRef
var rootRef
var rng
var shouldFollowTrainer = true
var speed = 30
var state = State.idle
var stopFollowThreshold = 4
var temp_rot
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

enum State {corral, idle, lasso, giddyup, pilot, search, follow, wander, knockback, attack, none, hors_de_combat}

var sfx_whinnys = [
	"res://sounds/horse_01.wav",
	"res://sounds/horse_03.wav"
]

var sfx_other = [
	"res://sounds/horse_02.wav"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	initialize_personality()
	enter_idle_state()
	pass # Replace with function body.

func _on_IdleTimer_timeout():
	#check if close enough to horse with high pep to have a conversation with
	pick_random_spot_nearby()
	$WalkTimer.start(rand_range(0.1,4.5))
	state = State.wander
	set_animation("Walk")

func _on_KnockbackTimer_timeout():
	enter_idle_state()
	pass # Replace with function body.

func _on_WalkTimer_timeout():
	enter_idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.attack:
			apply_gravity(delta)
			move_towards(attacking, delta)
		State.corral:
			apply_gravity(delta)
			move_towards(corral, delta)
		State.follow:
			apply_gravity(delta)
			move_towards(trainer, delta)
		State.idle:
			apply_gravity(delta)
			check_pep_thresh()
			if(has_enemy()):
				look_for(attacking, (followThreshold/2))
			elif(has_trainer() and shouldFollowTrainer):
				look_for(trainer)
		State.knockback:
			move_based_on_knockback(delta)
		State.lasso:
			wiggle(delta)
		State.pilot:
			apply_gravity(delta)
			move_based_on_input(delta)
		State.search:
			apply_gravity(delta)
			look_for(trainer)
		State.wander:
			apply_gravity(delta)
			wander(delta)

func apply_gravity(delta):
	if not is_on_floor():
		canJump = false
		fall.y -= gravity * delta
	else:
		canJump = true
	
	move_and_slide(fall, Vector3.UP)

func apply_rotation(input):
	if state == State.pilot:
		rotate_y(input.mouse_horizontal)

func attack():
	#set animation to attack
	print("ATTACKING ", attacking.name)
	set_animation("Attack")
	state = State.none
	$AttackHitboxTimer.start()

func calculate_knockback_vector(hitbox, player):
	print("type:  --- ",hitbox.get_class())
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

func can_be_charmed():
	return ((pep > -5) and (state != State.attack and state != State.hors_de_combat))

func can_be_lassoed():
	return (pep >= 0) or state == State.hors_de_combat

func check_if_alive():
	if(HP <= 0):
		queue_free()

func check_pep_thresh():
	if(pep > 0):
		#can join party
		pass
	if(pep > 10):
		#can interact with other horses whose pep are greater than 10
		pass

func check_relationships(person):
	if relationships.has(person):
		return relationships[person]
	else:
		return 0

func deal_damage(power):
	HP -= power
	check_if_alive()

func enter_giddyup(rider, root):
	stop_all_timers()
	rootRef = root
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
	knockback_direction = vector
	state = State.knockback
	$KnockbackTimer.start(0.2 * dmg)

func enter_pilot():
	stop_all_timers()
	playerRef.enter_pilot()
	play_random_sound()
	state = State.pilot
	subscribe_to()

func exit_giddyup():
	enter_idle_state()

func exit_pilot():
	print(trainer)
	unsubscribe_to()
	play_random_sound()
	if(has_trainer()):
		state = State.search	
	else:
		enter_idle_state()

func has_enemy():
	return attacking != null

func has_trainer():
	return trainer != null

func highlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://materials/horse_toon_highlighted.tres"))

func initialize_personality(mom = null, dad = null):
	if(isAggroAtStart):
		pep = rng.randi_range(-10,0)
	else:
		pep = 1
	var moodboard = [HorseMoods.heart, HorseMoods.diamond, HorseMoods.club, HorseMoods.spade, HorseMoods.greed, HorseMoods.bloodlust]
	personality = calculate_random_weights()
	var mood_vals = [2,1,0,0,-1,-2]
	for n in mood_vals:
		var i = roll_moods(personality)
		set_moods(moodboard, i, mood_vals[n])

func lasso(l):
	state = State.lasso
	impact_dir = l.rotation
	temp_rot = Vector3(rotation.x, rotation.y, rotation.z)

func look_for(target, r = 0):
	if report_distance(target) > (followThreshold if (r == 0) else r):
		if(target == attacking):
			set_target(target)
		elif(target == trainer):
			start_following_trainer()
		pass
	else:
		#gotta figure out what to do if the player remains in the attack zone
		pass

func look_for_enemy():
	if report_distance(attacking) > followThreshold:
		set_target(attacking)
	else:
		pass

func look_for_trainer():
	if report_distance(trainer) > followThreshold:
		start_following_trainer()
	else:
		pass

func move_based_on_input(delta):
	if is_on_floor():
		canJump = true
	else:
		canJump = false
		fall.y -= gravity * delta
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
	move_and_slide(fall, Vector3.UP)
	playerRef.rotation.y = rotation.y
	playerRef.global_transform.origin = saddle.global_transform.origin

func move_based_on_knockback(delta):
	move_and_slide(knockback_direction, Vector3.UP)
	apply_gravity(delta)

func move_towards(target, delta):
	print("~ ", state, " ~ moving towards ", target)
	var opposite = target.global_transform.origin.x - global_transform.origin.x
	var adjacent = target.global_transform.origin.z - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	var facing = -global_transform.basis.z * speed * 50 * delta
	move_and_slide(facing)
	if(report_distance(target) < stopFollowThreshold):
		if(target == trainer):
			stop_following_trainer()
		elif target == attacking:
			attack()
		else:
			enter_idle_state()

func parse_input(input):
	direction = Vector3()
	
	if input.space:
		if canJump == true:
			play_random_sound()
			fall.y = jump
			canJump = false
	
	direction += (input.forward * transform.basis.z * -1) + (input.backward * transform.basis.z)
	direction += (input.right * transform.basis.x) + (input.left * -1 * transform.basis.x)
	direction = direction.normalized()
	
	apply_rotation(input)

func pick_random_spot_nearby():
	var wander_range = 30
	var x = rand_range(-1,1) * wander_range
	var z = rand_range(-1,1) * wander_range
	var point = Vector3(global_transform.origin.x + x,global_transform.origin.y,global_transform.origin.z + z)
	var opposite = (global_transform.origin.x - x) - global_transform.origin.x
	var adjacent = (global_transform.origin.z - z) - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	#print(point)
	wandering_point = point

func play_random_sound():
	var sfx = load(sfx_other[randi() % sfx_other.size()])
	update_audio_stream(sfx)

func play_random_whinny():
	var sfx = load(sfx_whinnys[randi() % sfx_whinnys.size()])
	update_audio_stream(sfx)

func recieve_charm(charm, charmer):
	print("RECIEVED CHARM ", charm)
	if(relationships.has(charmer)):
		relationships[charmer] += mood[charm]
	else:
		relationships[charmer] = mood[charm]
	
	if(mood[charm] > 0):
		pep += 1
	elif(mood[charm] < 0):
		pep -= 1
	
	print("Relationship with ", charmer, " increased by ", mood[charm], " to ", relationships[charmer])
	print("Pep: ", pep)
	match(mood[charm]):
		2:
			$Particles.loved()
		1:
			$Particles.liked()
		-1:
			$Particles.disliked()
		-2:
			$Particles.hated()
	if(check_relationships(charmer) < -4):
		set_target(charmer)

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
	$full_rig_white2/AnimationPlayer.get_animation(clip).set_loop(true)
	$full_rig_white2/AnimationPlayer.play(clip)
	$full_rig_white2/AnimationPlayer.playback_speed = s
	$full_rig_white2/AnimationPlayer.seek(0)

func set_moods(mb, i, v):
	mood[mb[i]] = v
	personality.remove(i)
	mb.remove(i)

func set_target(enemy):
	print("target found: ", enemy.name, "!")
	start_following_target()
	attacking = enemy
	state = State.attack

func start_following_trainer():
	start_following_target()
	state = State.follow

func start_following_target():
	stop_all_timers()
	set_animation("Trot", 2.0)

func start_idle_timer():
	$IdleTimer.start(rand_range(0.1,4.5))

func stop_all_timers():
	$IdleTimer.stop()
	$WalkTimer.stop()
	$KnockbackTimer.stop()
	$AttackHitboxTimer.stop()
	$AttackCooldownTimer.stop()

func stop_following_trainer():
	enter_idle_state()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func take_damage(dmg, hitbox, player):
	print(self, " took ", dmg, " points of damage!")
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
	print("tamed ", name)
	stop_all_timers()
	trainer = tamer
	pep += 1
	play_random_whinny()
	if(!trainer.add_to_party(self)):
		print("party full")
		var corrals
		#contacts the corral registrar
		if(rootRef != null):
			corrals = rootRef.get_node("GlobalCorralRegistrar")
		else:
			rootRef = get_tree().get_root().get_node("World")
			corrals = rootRef.get_node("GlobalCorralRegistrar")
		corral = corrals.get_corral()
		print("travelling to ", corral)
		state = State.corral
		trainer.exit_pilot(false)
		shouldFollowTrainer = false
	else:
		enter_pilot()

func turn_and_face(target):
	var opposite = target.global_transform.origin.x - global_transform.origin.x
	var adjacent = target.global_transform.origin.z - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180

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

func wander(delta):
	move_and_slide(Vector3(global_transform.origin - wandering_point).normalized(), Vector3.UP)

func wiggle(delta):
	#rotation -= Vector3(0,impact_dir.y + 0.01,0)
	pass


func _on_AggroRange_area_entered(area):
	if pep < -5:
		if area.has_method("aggroable"):
			if (rng.randf_range(0.0, 1.0) < area.aggroable()):
				set_target(area)
		elif(area.owner != null):
			if area.owner.has_method("aggroable"):
				if (rng.randf_range(0.0, 1.0) < area.owner.aggroable()):
					set_target(area.owner)
	elif(check_relationships(area) < -4):
		set_target(area)
	elif(area.owner != null):
		if(check_relationships(area.owner) < -4):
			set_target(area.owner)
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
	if(report_distance(attacking) > followThreshold / 3):
		#need to move to get to player
		print("chasing target")
		set_target(attacking)
	else:
		#rotate to face player and keep attacking
		print("target close enough")
		turn_and_face(attacking)
		attack()
		pass
	pass # Replace with function body.
