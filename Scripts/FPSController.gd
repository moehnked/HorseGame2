extends KinematicBody

onready var head = $Head
onready var inputMacro = preload("res://Scripts/InputMacro.gd")
onready var ropeResource = preload("res://prefabs/LassoBullet.tscn")
onready var rootRef = get_tree().get_root().get_node("World")
onready var inventoryScreenSource = preload("res://prefabs/UI/InventoryScreen.tscn")


var aggro = 1
var acceleration = 20
var airAcceleration = 1
var canCastLeft = true
var canCastRight = true
var canCheckInventory = true
var canExitHorse = false
var canJump = true
var canUpdateHands = true
var direction = Vector3()
var fall = Vector3()
var flushing = false
var fullContact = false
var gravity = 20
var gravityVector = Vector3()
var HP = 10
var hAcceleration = 6
var hVelocity = Vector3()
var input = InputMacro.new()
var isBuilding = false
var jump = 10
var knockbackDirection = Vector3()
var mouseSensitivity = 0.09
var movement = Vector3()
var normalAcceleration = 6
var saddle
var scaleMod = 1.0
export var speed = 7

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

enum State {normal, lasso, giddyup, pilot, menu, knockback}

# Called when the node enters the scene tree for the first time.
func _ready():
	subscribe_to()
	scaleMod = scale.x
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _physics_process(delta):
	#print(global_transform.origin.y)
	match state:
		State.lasso:
			moveTowards(saddle, delta)
		State.knockback:
			move_based_on_knockback(delta)
		State.normal:
			update_raycast()
			apply_rotation()
			parse_movement(delta)
			move_based_on_input(delta)
		State.pilot:
			if Input.is_action_just_pressed("engage") and canExitHorse:
				exit_pilot()

func _on_ExitHorseTimer_timeout():
	print("times up")
	canExitHorse = true

func _on_InteractionController_area_entered(area):
	print(area)

func _on_LassoTimeout_timeout():
	state = State.normal
	pass

func _on_LeftCooldown_timeout():
	print("cast left cooldown complete....")
	canCastLeft = true

func _on_RightCooldown_timeout():
	print("cast right cooldown complete....")
	canCastRight = true

func add_to_party(member):
	print("===---=== ", $HUD.party.size(), " - ", $Head/Skull/Hat.level)
	if($HUD.party.size() < $Head/Skull/Hat.level):
		print("adding ", member.name, " to party")
		print("adding to party - ", member.name)
		$HUD.add_party_member(member)
		$HUD.draw_party()
		return true
	else:
		print("party_full")
		return false

func aggroable():
	return aggro

func apply_gravity(delta):
	if not is_on_floor():
		move_and_slide(fall, Vector3.UP)

func apply_rotation():
	if state != State.giddyup and not isBuilding:
		rotate_y(input.mouse_horizontal)

func calculate_knockback_vector(hitbox, source):
	print("type:  --- ",hitbox.get_class())
	return (hitbox.global_transform.origin - source.global_transform.origin) * 10
	pass

func cast(spell, callback, hand):
	$Head/Hand.update_hand_sprite(spell)
	get_viewport().warp_mouse(OS.window_size/2)
	random_grunt()
	var spellInstance = load("res://prefabs/Spells/" + spell + ".tscn").instance()
	spellInstance.initialize({'player':self, 'root':rootRef, 'palm':$Head/Palm, 'callback':callback, 'hand':hand})
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

func check_floor(delta):
	if is_on_floor():
		canJump = true
		#fall.y = 0
	else:
		canJump = false
		fall.y -= gravity * delta

func conclude_spell(spell):
	print("spell ", spell, " hase concluded...")
	if $LeftCooldown.time_left <= 0:
		canCastLeft = true
	if $RightCooldown.time_left <= 0:
		canCastRight = true
	$Head/Hand.idle_hand()
	flush_spells()

func correct_scale():
	scale = Vector3(scaleMod, scaleMod, scaleMod)

func toggle_all_collisions(tog = false):
	$CollisionShape.disabled = tog
	$InteractionController/CollisionShape.disabled = tog
	$Foot.disabled = tog
	$GroundCheck.enabled = not tog

func enable_casting():
	canCastLeft = true
	canCastRight = true

func enter_dialogue(other):
	unsubscribe_to()
	get_head().look_at_object(other)
	$InteractionController.disable_interact()

func enter_giddyup(target):
	print("player enter_giddyup")
	$LassoTimeout.stop()
	canExitHorse = false
	global_transform = target.global_transform
	scale = Vector3(scaleMod,scaleMod,scaleMod)
	state = State.giddyup
	$CollisionShape.disabled = true
	$InteractionController/CollisionShape.disabled = true
	saddle.owner.enter_giddyup(self, rootRef)

func enter_inventory():
	enter_some_menu()
	var screen = inventoryScreenSource.instance()
	screen.initialize({'source':self, 'root':rootRef, 'inv':get_inventory(), 'callback':"exit_inventory"})
	rootRef.call_deferred("add_child", screen)

func enter_knockback(vector, dmg):
	revoke_casting()
	revoke_menu_options()
	unsubscribe_to()
	$Head.unsubscribe_to()
	knockbackDirection = vector
	state = State.knockback
	$KnockbackTimer.start(0.2 * dmg)

func enter_some_menu():
	unsubscribe_to()
	$Head.unsubscribe_to()
	state = State.menu
	canUpdateHands = false
	canCheckInventory = false
	revoke_casting()

func enter_pilot():
	$ExitHorseTimer.start()
	state = State.pilot
	toggle_all_collisions(true)
	unsubscribe_to()

func enter_update_hands_menu():
	enter_some_menu()
	var menu = load("res://prefabs/UI/Update_Hands.tscn").instance()
	menu.initialize(self, rootRef, lefthandSpell, righthandSpell)
	rootRef.call_deferred("add_child", menu)
	print("updating hands")

func exit_build_mode(callback):
	canUpdateHands = true
	canCheckInventory = true
	call(callback)

func exit_dialogue():
	subscribe_to()
	get_head().unfocus()
	$InteractionController.enable_interact()

func exit_inventory():
	exit_some_menu()

func exit_pilot(callback = true):
	print("exiting pilot")
	state = State.normal
	if(callback):
		saddle.owner.exit_pilot()
#	$CollisionShape.disabled = false
#	$InteractionController/CollisionShape.disabled = false
	toggle_all_collisions(false)
	subscribe_to()

func exit_some_menu():
	subscribe_to()
	$Head.subscribe_to()
	state = State.normal
	canUpdateHands = true
	canCheckInventory = true
	queue_spell_clear()
	enable_casting()

func exit_update_hands_menu():
	exit_some_menu()

func flush_spells():
	for o in raycastObservers:
		raycast_unsubscribe(o)
		#o.queue_free()
	flushing = false

func get_inventory():
	return $InteractionController.inventory

func get_hand():
	return $Head/Hand

func get_head():
	return $Head

func get_palm():
	return $Head/Palm

func initializeHUD(letter):
	$Head/Camera/GuiLoadArea/H.initialize(letter)

func is_player():
	return true

func lasso(saddle):
	state = State.lasso
	self.saddle = saddle

func move_based_on_input(delta):
	direction = direction.normalized()
	hVelocity = hVelocity.linear_interpolate(direction * speed, hAcceleration * delta)
	movement.z = hVelocity.z + gravityVector.z
	movement.x = hVelocity.x + gravityVector.x
	movement.y = gravityVector.y
	move_and_slide(movement, Vector3.UP)

func move_based_on_knockback(delta):
	move_and_slide(knockbackDirection, Vector3.UP)
	apply_gravity(delta)

func moveTowards(target, delta):
	var opposite = target.global_transform.origin.x - global_transform.origin.x
	var adjacent = target.global_transform.origin.z - global_transform.origin.z
	var angle = atan2(opposite, adjacent)
	rotation_degrees.y = rad2deg(angle) - 180
	var facing = -global_transform.basis.z * speed * 200 * delta
	move_and_slide(facing)
	if(global_transform.origin.distance_to(target.global_transform.origin) < 5):
		enter_giddyup(target)

func parse_input(_input):
	input = _input
	
	if input.standard:
		if canCastLeft:
			if flushing:
				flush_spells()
			else:
				cast_left()
	elif input.special:
		if canCastRight:
			if flushing:
				flush_spells()
			else:
				cast_right()
	elif input.mouse_up:
		if canUpdateHands:
			enter_update_hands_menu()
	elif input.tab:
		if canCheckInventory:
			enter_inventory()

func parse_movement(delta):
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

func placer_subscribe(placer):
	placer_observers.append(placer)

func placer_unsubscribe(placer):
	placer_observers.erase(placer)

func play_sound(sound_path):
	$AudioStreamPlayer.stream = load(sound_path)
	$AudioStreamPlayer.play()

func queue_spell_clear():
	flushing = true

func random_grunt():
	randomize()
	var grunt = sfx_grunts[randi() % sfx_grunts.size()]
	play_sound(grunt)

func raycast_subscribe(placer):
	if(!raycastObservers.has(placer)):
		raycastObservers.append(placer)

func raycast_unsubscribe(placer):
	raycastObservers.erase(placer)

func remove_from_party(member):
	$HUD.remove_from_party(member)

func report_damage(member):
	#reprot member damage to party
	$HUD.report(member)
	pass

func restore_menu_options():
	canUpdateHands = true
	canCheckInventory = true

func return_control():
	subscribe_to()
	$Head.subscribe_to()
	state = State.normal

func revoke_casting():
	canCastLeft = false
	canCastRight = false
	stop_cast_reset()

func revoke_menu_options():
	canUpdateHands = false
	canCheckInventory = false

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

func take_damage(dmg = 1, hitbox = null, source = null):
	HP -= dmg
	$HUD.update_display(HP)
	if(HP <= 0):
		#GAME OVER
		pass
	else:
		enter_knockback(calculate_knockback_vector(hitbox, source), dmg)
		pass

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	rootRef.get_node("InputObserver").unsubscribe($InteractionController)

func update_placer_position(point):
	for placer in placer_observers:
		placer.update_position(point, self.global_transform.origin)

func update_raycast():
	if $Head/Camera/RayCast.is_colliding():
		update_placer_position($Head/Camera/RayCast.get_collision_point())
		for o in raycastObservers:
			o.parse_raycast($Head/Camera/RayCast)
	else:
		for o in raycastObservers:
			o.clear_raycast()

func update_spells(left, right):
	lefthandSpell = left
	righthandSpell = right


func _on_KnockbackTimer_timeout():
	state = State.normal
	enable_casting()
	restore_menu_options()
	subscribe_to()
	$Head.subscribe_to()
	pass # Replace with function body.
