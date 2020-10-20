extends KinematicBody
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

onready var challengeResource = preload("res://giddyup_challenge.tscn")
onready var saddle = $Saddle

var acceleration = 20
var bloodlust_rate
var canJump = true
var direction = Vector3()
var fall = Vector3()
var followThreshold = 20.0
var gravity = 11.2
var greed_rate
var health = 10
var hp = 10
var impact_dir
var jump = 10
var knockback_direction = Vector3()
var mouseSensitivity = 0.2
var personality
var playerRef
var rootRef
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

enum State {idle, lasso, giddyup, pilot, search, follow, wander, knockback}

var sfx_whinnys = [
	"res://sounds/horse_01.wav",
	"res://sounds/horse_03.wav"
]

var sfx_other = [
	"res://sounds/horse_02.wav"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_personality()
	enter_idle_state()
	pass # Replace with function body.

func _on_IdleTimer_timeout():
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
		State.idle:
			apply_gravity(delta)
			if(has_trainer()):
				look_for_trainer()
			else:
				pass
		State.wander:
			apply_gravity(delta)
			wander(delta)
		State.lasso:
			wiggle(delta)
		State.search:
			look_for_trainer()
		State.follow:
			apply_gravity(delta)
			move_towards(trainer, delta)
		State.pilot:
			move_based_on_input(delta)
		State.knockback:
			move_based_on_knockback(delta)

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

func check_if_alive():
	if(hp <= 0):
		queue_free()

func deal_damage(power):
	hp -= power
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

func has_trainer():
	return trainer != null

func highlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://materials/horse_toon_highlighted.tres"))

func initialize_personality(mom = null, dad = null):
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

func look_for_trainer():
	if report_distance() > followThreshold:
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
	var opposite = target.global_transform.origin.x - global_transform.origin.x
	var adjacent = target.global_transform.origin.z - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	var facing = -global_transform.basis.z * speed * 50 * delta
	move_and_slide(facing)
	if(report_distance() < stopFollowThreshold):
		stop_following_trainer()

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
	#print("picking random point...")
	var wander_range = 30
	var x = rand_range(-1,1) * wander_range
	var z = rand_range(-1,1) * wander_range
	var point = Vector3(global_transform.origin.x + x,global_transform.origin.y,global_transform.origin.z + z)
	var opposite = (global_transform.origin.x - x) - global_transform.origin.x
	var adjacent = (global_transform.origin.z - z) - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	print(point)
	wandering_point = point

func play_random_sound():
	var sfx = load(sfx_other[randi() % sfx_other.size()])
	update_audio_stream(sfx)

func play_random_whinny():
	var sfx = load(sfx_whinnys[randi() % sfx_whinnys.size()])
	update_audio_stream(sfx)

func recieve_charm(charm, charmer):
	print("RECIEVED CHARM ", charm)
	relationships[charmer] = mood[charm]
	#print(relationships)
	match(mood[charm]):
		2:
			$Particles.loved()
		1:
			$Particles.liked()
		-1:
			$Particles.disliked()
		-2:
			$Particles.hated()

func report_distance():
	return global_transform.origin.distance_to(trainer.global_transform.origin)

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

func set_moods(mb, i, v):
	mood[mb[i]] = v
	personality.remove(i)
	mb.remove(i)

func start_following_trainer():
	stop_all_timers()
	set_animation("Trot", 2.0)
	state = State.follow

func start_idle_timer():
	$IdleTimer.start(rand_range(0.1,4.5))

func stop_all_timers():
	$IdleTimer.stop()
	$WalkTimer.stop()

func stop_following_trainer():
	enter_idle_state()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func take_damage(dmg, hitbox, player):
	print(self, " took ", dmg, " points of damage!")
	hp -= dmg
	if(hp <= 0):
		queue_free()
	else:
		enter_knockback(calculate_knockback_vector(hitbox, player), dmg)
		pass

func tame(tamer):
	stop_all_timers()
	trainer = tamer
	play_random_whinny()
	enter_pilot()

func unhighlight():
	$full_rig_white2/RM_White_Horse_Rig/Skeleton/RM_White_Horse.set_surface_material(0, load("res://materials/horse_toon.tres"))

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func update_audio_stream(sfx):
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stream = sfx
		$AudioStreamPlayer.play()

func wander(delta):
	move_and_slide(Vector3(global_transform.origin - wandering_point).normalized(), Vector3.UP)

func wiggle(delta):
	#rotation -= Vector3(0,impact_dir.y + 0.01,0)
	pass
