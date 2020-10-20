extends KinematicBody

onready var head = $Head
onready var ropeResource = preload("res://prefabs/LassoBullet.tscn")
onready var rootRef = get_tree().get_root().get_node("World")
onready var inventoryScreenSource = preload("res://prefabs/UI/InventoryScreen.tscn")

var acceleration = 20
var canCastLeft = true
var canCastRight = true
var canCheckInventory = true
var canExitHorse = false
var canJump = true
var canUpdateHands = true
var direction = Vector3()
var fall = Vector3()
var gravity = 9.8
var isBuilding = false
var jump = 5
var mouse_sensitivity = 0.2
var saddle
var speed = 15
var state = State.normal
var velocity = Vector3()

var placer_observers = []
var raycastObservers = []

var lefthandSpell = "Build"
var righthandSpell = "Lasso"

var buildList = ["Fence", "Gate", "Wall", "Doorway"]

var sfx_grunts = [
	"res://sounds/grunt_01.wav",
	"res://sounds/grunt_02.wav",
	"res://sounds/grunt_03.wav",
]

enum State {normal, lasso, giddyup, pilot, menu}

# Called when the node enters the scene tree for the first time.
func _ready():
	subscribe_to()
	pass # Replace with function body.

func _process(delta):
	match state:
		State.normal:
			#getInput(delta)
			move_based_on_input(delta)
		State.lasso:
			moveTowards(saddle, delta)
		State.pilot:
			if Input.is_action_just_pressed("engage") and canExitHorse:
				exit_pilot()

func _physics_process(delta):
	if $Head/Camera/RayCast.is_colliding():
		update_placer_position($Head/Camera/RayCast.get_collision_point())
		for o in raycastObservers:
			o.parse_raycast($Head/Camera/RayCast)
	else:
		for o in raycastObservers:
			o.clear_raycast()

func _on_ExitHorseTimer_timeout():
	print("times up")
	canExitHorse = true

func _on_InteractionController_area_entered(area):
	print(area)

func _on_LassoTimeout_timeout():
	state = State.normal
	#global_transform = global_transform
	pass

func _on_LeftCooldown_timeout():
	print("cast left cooldown complete....")
	canCastLeft = true

func _on_RightCooldown_timeout():
	print("cast right cooldown complete....")
	canCastRight = true

func apply_rotation(input):
	if state != State.giddyup and not isBuilding:
		rotate_y(input.mouse_horizontal)

func cast(spell, callback, hand):
	$Head/Hand.update_hand_sprite(spell)
	get_viewport().warp_mouse(OS.window_size/2)
	random_grunt()
	var spellInstance = load("res://prefabs/Spells/" + spell + ".tscn").instance()
	spellInstance.initialize(self, rootRef, $Head/Palm, callback, hand)
	rootRef.call_deferred("add_child", spellInstance)

func cast_left():
	if canCastLeft:
		print("casting left")
		canCastLeft = false
		cast(lefthandSpell, "startLeftCooldown", "left")

func cast_right():
	if canCastRight:
		print("casting right")
		canCastRight = false
		cast(righthandSpell, "startRightCooldown", "right")

func conclude_spell(spell):
	print("spell ", spell, " hase concluded...")
	if $LeftCooldown.time_left <= 0:
		canCastLeft = true
	if $RightCooldown.time_left <= 0:
		canCastRight = true
	$Head/Hand.idle_hand()
	flush_spells()

func enable_casting():
	canCastLeft = true
	canCastRight = true

func enter_giddyup(target):
	print("player enter_giddyup")
	$LassoTimeout.stop()
	canExitHorse = false
	global_transform = target.global_transform
	scale = Vector3(1,1,1)
	state = State.giddyup
	$CollisionShape.disabled = true
	$InteractionController/CollisionShape.disabled = true
	saddle.owner.enter_giddyup(self, rootRef)

func enter_inventory():
	print("ENTERRING INVENTORY")
	canCheckInventory = false
	canUpdateHands = false
	revoke_casting()
	var screen = inventoryScreenSource.instance()
	screen.initialize(self, rootRef, get_inventory(), "exit_inventory")
	rootRef.call_deferred("add_child", screen)

func enter_pilot():
	$ExitHorseTimer.start()
	state = State.pilot
	unsubscribe_to()

func enter_update_hands_menu():
	unsubscribe_to()
	state = State.menu
	canUpdateHands = false
	canCheckInventory = false
	$Head.unsubscribe_to()
	var menu = load("res://prefabs/UI/Update_Hands.tscn").instance()
	menu.initialize(self, rootRef, lefthandSpell, righthandSpell)
	rootRef.call_deferred("add_child", menu)
	revoke_casting()
	print("updating hands")

func exit_build_mode(callback):
	canUpdateHands = true
	canCheckInventory = true
	call(callback)

func exit_inventory():
	print("EXITING INVENTORY")
	canCheckInventory = true
	canUpdateHands = true
	enable_casting()
	pass

func exit_pilot():
	print("exiting pilot")
	state = State.normal
	saddle.owner.exit_pilot()
	$CollisionShape.disabled = false
	$InteractionController/CollisionShape.disabled = false
	subscribe_to()

func exit_update_hands_menu():
	subscribe_to()
	state = State.normal
	canUpdateHands = true
	canCheckInventory = true
	$Head.subscribe_to()
	enable_casting()
	flush_spells()

func flush_spells():
	for o in raycastObservers:
		raycast_unsubscribe(o)
		#o.queue_free()
	pass

func get_inventory():
	return $InteractionController.inventory

func lasso(saddle):
	state = State.lasso
	self.saddle = saddle

func move_based_on_input(delta):
	if is_on_floor():
		canJump = true
	else:
		canJump = false
		fall.y -= gravity * delta
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)

func moveTowards(target, delta):
	var opposite = target.global_transform.origin.x - global_transform.origin.x
	var adjacent = target.global_transform.origin.z - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	var facing = -global_transform.basis.z * speed * 200 * delta
	move_and_slide(facing)
	if(global_transform.origin.distance_to(target.global_transform.origin) < 5):
		enter_giddyup(target)

func parse_input(input):
	direction = Vector3()
	
	if input.space:
		if canJump == true:
			random_grunt()
			fall.y = jump
			canJump = false
	
	direction += (input.forward * transform.basis.z * -1) + (input.backward * transform.basis.z)
	direction += (input.right * transform.basis.x) + (input.left * -1 * transform.basis.x)
	direction = direction.normalized()
	
	apply_rotation(input)
	
	if input.standard:
		if canCastLeft:
			cast_left()
	elif input.special:
		if canCastRight:
			cast_right()
	elif input.mouse_up:
		if canUpdateHands:
			enter_update_hands_menu()
	elif input.tab:
		if canCheckInventory:
			enter_inventory()

func placer_subscribe(placer):
	placer_observers.append(placer)

func placer_unsubscribe(placer):
	placer_observers.erase(placer)

func play_sound(sound_path):
	$AudioStreamPlayer.stream = load(sound_path)
	$AudioStreamPlayer.play()

func random_grunt():
	randomize()
	var grunt = sfx_grunts[randi() % sfx_grunts.size()]
	play_sound(grunt)

func raycast_subscribe(placer):
	raycastObservers.append(placer)

func raycast_unsubscribe(placer):
	raycastObservers.erase(placer)

func revoke_casting():
	canCastLeft = false
	canCastRight = false
	stop_cast_reset()

func setLassoLimit():
	$LassoTimeout.start()

func startLeftCooldown():
	$LeftCooldown.start()
	
func startRightCooldown():
	$RightCooldown.start()

func stop_cast_reset():
	$LeftCooldown.stop()
	$RightCooldown.stop()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)
	rootRef.get_node("InputObserver").subscribe($InteractionController)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	rootRef.get_node("InputObserver").unsubscribe($InteractionController)

func update_placer_position(point):
	for placer in placer_observers:
		placer.update_position(point, self.global_transform.origin)

func update_spells(left, right):
	lefthandSpell = left
	righthandSpell = right
