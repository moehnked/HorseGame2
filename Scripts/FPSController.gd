extends KinematicBody

onready var head = $Head
onready var inputMacro = preload("res://Scripts/InputMacro.gd")
onready var ropeResource = preload("res://prefabs/LassoBullet.tscn")
onready var inventoryScreenSource = preload("res://prefabs/UI/InventoryScreen.tscn")


export var DEACCEL = 6
export var MAX_SPEED = 40
export var MAX_ACCEL = 2
export var MAX_SLOPE_ANGLE = 90

var camera_angle = 0
var camera_change = Vector2()

var has_contact = false

var mouse_sensitivity = 0.3

var aggro = 1
var canCastLeft = true
var canCastRight = true
var canCheckInventory = true
#var canExitHorse = false
var canJump = true
var canUpdateHands = true
var fall = Vector3()
var flushing = false
var fullContact = false
var gravityVector = Vector3()
var gravityCoefficient = 1.0
var HP = 10
var input = InputMacro.new()
var isBuilding = false
var isSwimming = false
var jump = 10
var jumpCoefficient = 1.0
var knockbackDirection = Vector3()
var mouseSensitivity = 0.09
var normalAcceleration = 6
var saddle
var scaleMod = 1.0
#var state = State.normal

var placer_observers = []
var raycastObservers = []

var lefthandSpell = "Build"
var righthandSpell = "Lasso"

var buildList = ["Fence", "Gate", "Wall", "Doorway", "Platform", "Staircase"]

var sfx_grunts = [
	"res://sounds/grunt_01.wav",
	"res://sounds/grunt_02.wav",
	"res://sounds/grunt_03.wav",
	"res://sounds/grunt_04.wav",
	"res://sounds/grunt_05.wav",
]

onready var currentBehavior = get_node("StateContainer/Normal")

func _ready():
	Global.Player = self
	subscribe_to()
	scaleMod = scale.x
	correct_scale()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$InteractionController.initialize_raycast(get_raycast())
	pass # Replace with function body.

func _physics_process(delta):
	currentBehavior.run_state(self, delta)

#func _on_ExitHorseTimer_timeout():
#	print("times up")
#	canExitHorse = true

func _on_LassoTimeout_timeout():
	#state = State.normal
	set_behavior("Normal")
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

func calculate_knockback_vector(hitbox, source):
	print("type:  --- ",hitbox.get_class())
	return (hitbox.global_transform.origin - source.global_transform.origin) * 10
	pass

func cast(spell, callback, hand):
	$Head/Hand.update_hand_sprite(spell)
	get_viewport().warp_mouse(OS.window_size/2)
	random_grunt()
	var spellInstance = load("res://prefabs/Spells/" + spell + ".tscn").instance()
	spellInstance.initialize({'player':self, 'root':Global.world, 'palm':$Head/Palm, 'callback':callback, 'hand':hand})
	Global.world.call_deferred("add_child", spellInstance)

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

func correct_scale():
	scale = Vector3(scaleMod, scaleMod, scaleMod)

func disable_collisions():
	$CollisionShape.disabled = true
	pass

func toggle_all_collisions(tog = false):
	$CollisionShape.disabled = tog
	$GroundCheck.enabled = not tog

func enable_casting():
	canCastLeft = true
	canCastRight = true

func enter_dialogue(other):
	unsubscribe_to()
	get_head().look_at_object(other)
	$InteractionController.disable_interact()

func enter_inventory():
	enter_some_menu()
	var screen = inventoryScreenSource.instance()
	screen.initialize({'source':self, 'inv':get_inventory(), 'callback':"exit_inventory"})
	Global.world.call_deferred("add_child", screen)

func enter_some_menu():
	set_behavior("Menu")

func enter_pilot():
	set_behavior("Pilot", {"actor":self})

func enter_update_hands_menu():
	enter_some_menu()
	var menu = load("res://prefabs/UI/Update_Hands.tscn").instance()
	menu.initialize(self, lefthandSpell, righthandSpell)
	Global.world.call_deferred("add_child", menu)
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
	set_behavior("Normal")
	if(callback):
		saddle.owner.exit_pilot()
	toggle_all_collisions(false)
	subscribe_to()

func exit_some_menu():
	set_behavior("Normal")

func exit_update_hands_menu():
	exit_some_menu()

func flush_spells():
	for o in raycastObservers:
		raycast_unsubscribe(o)
	flushing = false

func get_camera():
	return $Head/Camera

func get_ground_check():
	return $GroundCheck

func get_inventory():
	return $InteractionController.inventory

func get_hand():
	return $Head/Hand

func get_head():
	return $Head

func get_palm():
	return $Head/Palm

func get_raycast():
	return $Head/Camera/RayCast_Areas

func get_solid_raycast():
	return $Head/Camera/RayCast_Solids

func initializeHUD(letter):
	$Head/Camera/GuiLoadArea/H.initialize(letter)

func is_player():
	return true

func lasso(saddle):
	set_behavior("Lasso")
	self.saddle = saddle

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
	set_behavior("Normal")

func revoke_casting():
	canCastLeft = false
	canCastRight = false
	stop_cast_reset()

func revoke_menu_options():
	canUpdateHands = false
	canCheckInventory = false

func setLassoLimit():
	$LassoTimeout.start()

func set_behavior(statename, init_args = {"actor": self}):
	currentBehavior = get_node("StateContainer/" + statename)
	currentBehavior.initialize(init_args)

func set_knockback_timer(time):
	$KnockbackTimer.start(time)

func startLeftCooldown():
	$LeftCooldown.start()
	
func startRightCooldown():
	$RightCooldown.start()

func start_swimming():
	gravityCoefficient = 0.1
	jumpCoefficient = 0.2
	isSwimming = true
	#get_head().set_mask(Color(0, 0.80, 0.93, 0.32))

#func start_timer_exit_horse():
#	$ExitHorseTimer.start()

func stop_cast_reset():
	$LeftCooldown.stop()
	$RightCooldown.stop()

func stop_lasso_timer():
	$LassoTimeout.stop()

func stop_swimming():
	gravityCoefficient = 1.0
	jumpCoefficient = 1.0
	isSwimming = false

func subscribe_to():
	Global.InputObserver.subscribe(self)
	Global.InputObserver.subscribe($InteractionController)

func take_damage(dmg = 1, hitbox = null, source = null):
	HP -= dmg
	$HUD.update_display(HP)
	if(HP <= 0):
		#GAME OVER
		pass
	else:
		set_behavior("Knockback", {"actor":self, "vector": calculate_knockback_vector(hitbox, source), "dmg": dmg})
		#enter_knockback(, dmg)
		pass

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)
	Global.InputObserver.unsubscribe($InteractionController)

func update_spells(left, right):
	lefthandSpell = left
	righthandSpell = right


func _on_KnockbackTimer_timeout():
	set_behavior("Normal")
	enable_casting()
	restore_menu_options()
	subscribe_to()
	$Head.subscribe_to()
	pass # Replace with function body.
