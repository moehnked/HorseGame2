extends KinematicBody

onready var head = $Head

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
var canResetCasting = true
var canUpdateHands = true
var chips = 50
var fall = Vector3()
var flushing = false
var fullContact = false
var gravityVector = Vector3()
var gravityCoefficient = 1.0
var hasBuildingRights
var HP = 10
var input = InputMacro.new()
var isBuilding = false
var isSwimming = false
var isRunning = true
var jump = 10
var jumpCoefficient = 1.0
var knockbackDirection = Vector3()
var lassoRef = null
var mouseSensitivity = 0.09
var normalAcceleration = 6
var saddle
var scaleMod = 1.0
var spellqueue = []
var uid = 0


var placer_observers = []
var raycastObservers = []

var lefthandSpell = "Null"
var righthandSpell = "Null"

var buildList = []
export(Array, String) var spellList = ["Null"]
export var treats:float = 20

onready var currentBehavior = get_node("StateContainer/Normal")

func _ready():
	Global.Player = self
	#set_behavior("Normal")
	scaleMod = scale.x
	correct_scale()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_interaction_controller().set_raycast(get_raycast())
	call_deferred("set_behavior", "Normal")
	set_uid(Global.GEIDR.generate_uid(self))
	pass # Replace with function body.

func _physics_process(delta):
	if isRunning:
		currentBehavior.run_state(self, delta)

#func _on_ExitHorseTimer_timeout():
#	print("times up")
#	canExitHorse = true

func _on_LassoTimeout_timeout():
	#state = State.normal
	#set_behavior("Normal")
	pass

func _on_LeftCooldown_timeout():
	print("cast left cooldown complete....")
	canCastLeft = canResetCasting

func _on_RightCooldown_timeout():
	print("cast right cooldown complete....")
	canCastRight = canResetCasting

func add_blueprint(plan):
	if not buildList.has(plan):
		buildList.append(plan)

func add_spell(spellname):
	if not spellList.has(spellname):
		spellList.append(spellname)

func add_to_party(member):
	#print("===---=== ", $HUD.party.size(), " - ", $Head/Skull/Hat.level)
	#if($HUD.party.size() < $Head/Skull/Hat.level):
	if $HUD.check_party_size():
		print("adding ", member.name, " to party")
		print("adding to party - ", member.name)
		$HUD.add_party_member(member)
		$HUD.draw_party()
		Utils.reparent(member, Global.world)
		return true
	else:
		print("party_full")
		return false

func aggroable():
	return aggro

func calculate_knockback_vector(hitbox, source):
	print("type:  --- ",hitbox.get_class())
	#return (hitbox.global_transform.origin - source.global_transform.origin) * 10
	return 10 * Vector3(1,0,1)
	pass

func can_exit_horse():
	#return $StateContainer/Pilot.canExitHorse
	return true

func cast(spell, callback, hand):
	print("casting ", spell)
	$Head/Hand.update_hand_sprite(spell)
	get_viewport().warp_mouse(OS.window_size/2)
	random_grunt()
	var spellInstance = load("res://prefabs/Spells/" + spell + ".tscn").instance()
	spellInstance.initialize({'player':self, 'root':Global.world, 'palm':$Head/Palm, 'callback':callback, 'hand':hand})
	Global.world.call_deferred("add_child", spellInstance)
	spellqueue.append(spell)

func cast_left():
	if canCastLeft and lefthandSpell != "Null":
		print("casting left")
		canCastLeft = false
		cast(lefthandSpell, "startLeftCooldown", "left")

func cast_right():
	if canCastRight and righthandSpell != "Null":
		print("casting right")
		canCastRight = false
		cast(righthandSpell, "startRightCooldown", "right")

func conclude_spell(spell):
	print("spell ", spell, " hase concluded...")
	if $LeftCooldown.time_left <= 0:
		canCastLeft = canResetCasting
	if $RightCooldown.time_left <= 0:
		canCastRight = canResetCasting
	$Head/Hand.idle_hand()
	flush_spell(spell)
	spellqueue.remove(0)

func correct_scale():
	#scale = Vector3(scaleMod, scaleMod, scaleMod)
	scale = Vector3(.456,.456,.456)


func disable_collisions():
	$CollisionShape.disabled = true
	pass

func enable_casting():
	canCastLeft = true
	canCastRight = true

func enable_cast_menu():
	canUpdateHands = true

func enter_dialogue(other):
	unsubscribe_to()
	get_head().look_at_object(other)
	get_interaction_controller().disable_interact()

func enter_inventory():
	enter_some_menu()
	var screen = load("res://prefabs/UI/InventoryScreens/BaseInventoryScreen.tscn").instance()
	screen.initialize({'source':self, 'inv':get_inventory(), 'callback':"exit_inventory"})
	Global.world.call_deferred("add_child", screen)
	
func enter_journal():
	enter_some_menu()
#	var screen = load("res://prefabs/UI/InventoryScreens/JournalMenu.tscn").instance()
#	screen.initialize({'source':self, 'inv':get_inventory(), 'callback':"exit_inventory"})
#	Global.world.call_deferred("add_child", screen)
#	Utils.show_mouse(true)
	var screen = Global.world.instantiate(load("res://prefabs/UI/InventoryScreens/JournalMenu.tscn").instance())
	screen.initialize({'source':self, 'callback':"exit_inventory"})

func enter_some_menu():
	get_head().stop()
	set_behavior("Menu")

func enter_pilot():
	print("FPS entring pilot")
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
	Global.world.queue_timer(self, 0.2, "exit_dialogue_timeout")

func exit_dialogue_timeout():
	print("player exitting dialogue")
	subscribe_to()
	get_head().unfocus()
	get_interaction_controller().enable_interact()

func exit_inventory():
	exit_some_menu()

func exit_pilot(callback = true):
	print("exiting pilot")
	set_behavior("Normal")
#	if(callback):
#		saddle.owner.exit_pilot()
	$StateContainer/Pilot.unsubscribe_to()
	toggle_all_collisions(false)
	subscribe_to()

func exit_some_menu():
	set_behavior("Normal")

func exit_update_hands_menu():
	exit_some_menu()

func flush_spell(spell):
	print("FLUSHING SPELL ", spell)
	print(raycastObservers)
	for o in raycastObservers:
		print(o, " , ", o.name, " - ", spell)
		if o.spellname == spell and spell != null:
			raycast_unsubscribe(o)
	flushing = false

func get_command_raycast():
	return $Head/Camera/RayCast_Command

func get_camera():
	return $Head/Camera

func get_equipped():
	return get_equipment_manager().equipped

func get_equipment_manager():
	#return $EquipmentManager
	return get_node("EquipmentManager")

func get_ground_check():
	return $GroundCheck

func get_input():
	if not input is InputMacro:
		input = InputMacro.new()
	return input
	

func get_interaction_controller():
	return get_node("InteractionManager")

func get_inventory():
	return get_equipment_manager().get_inventory()

func get_hat():
	return $Head/Skull/Hat

func get_hand():
	return $Head/Hand

func get_head():
	return $Head
#
#func get_load_priority():
#	return 2

func get_hud():
	return $HUD

func get_palm():
	return $Head/Palm

func get_party(asKeys = true):
	return $HUD.query_party()

func get_pos():
	return global_transform.origin

func get_raycast():
	return $Head/Camera/RayCast_Areas

func get_spell_list():
	return spellList

func get_solid_raycast():
	return $Head/Camera/RayCast_Solids

func get_state():
	return currentBehavior.name

func get_treats():
	return treats

func get_uid():
	return uid

func get_x_rotation():
	return get_head().rotation.x

func get_velocity():
	return $StateContainer/Normal.velocity

func hide_hud():
	$HUD.visible = false

func initializeHUD(letter):
	$Head/Camera/GuiLoadArea/H.initialize(letter)

func is_collision_enabled():
	return not $CollisionShape.disabled

func is_player():
	return true

func is_focused():
	return get_head().is_focused()

func parse_input(_input):
	input = _input
	
	if Input.is_key_pressed(KEY_P):
		for h in get_party():
			print("party: ", h, h.get_name(), h.global_transform.origin)
	
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
	elif input.journal:
		if canCheckInventory:
			enter_journal()

func placer_subscribe(placer):
	placer_observers.append(placer)

func placer_unsubscribe(placer):
	placer_observers.erase(placer)

func play_sound(sound_path):
	$AudioStreamPlayer.stream = load(sound_path)
	$AudioStreamPlayer.play()

func queue_spell_clear():
	print("Queuing speel clear")
	flushing = true

func random_grunt():
	$GruntSfx.trigger()

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

func revoke_cast_menu():
	canUpdateHands = false

func revoke_menu_options():
	canUpdateHands = false
	canCheckInventory = false

func save():
	#Utils.save_items_from_list(get_inventory(), get_equipped())
	return Utils.serialize_node(self)

func set_lasso_limit():
	$LassoTimeout.start()

func set_behavior(statename, init_args = {}):
	currentBehavior = get_node("StateContainer/" + statename)
	currentBehavior.initialize(Utils.check(init_args, {"actor": self}))

func set_is_running(val = true):
	isRunning = val

func set_knockback_timer(time):
	$KnockbackTimer.start(time)

func set_treats(val):
	treats = val

func set_velocity(vel):
	$StateContainer/Normal.velocity = vel

func set_uid(_uid):
	uid = _uid

func set(param, val):
	match param:
		"uid":
			set_uid(int(val))
			Global.GEIDR.register(self)
		_:
			.set(param, val)

func show_hud():
	$HUD.visible = true

func startLeftCooldown():
	$LeftCooldown.start()
	
func startRightCooldown():
	$RightCooldown.start()

func start_swimming():
	gravityCoefficient = 0.1
	jumpCoefficient = 0.2
	isSwimming = true
	Global.AudioManager.play_sound("res://Sounds/splash/splash" + String(Global.world.rng.randi_range(1,3)) + ".wav",-5,Global.world.rng.randf_range(-6,3))

func stop_cast_reset():
	$LeftCooldown.stop()
	$RightCooldown.stop()
	canResetCasting = false

func stop_lasso_timer():
	$LassoTimeout.stop()

func stop_swimming():
	gravityCoefficient = 1.0
	jumpCoefficient = 1.0
	isSwimming = false
	Global.AudioManager.play_sound("res://Sounds/splash/splash" + String(Global.world.rng.randi_range(1,3)) + ".wav",-5,Global.world.rng.randf_range(-6,3))

func subscribe_to():
	Global.InputObserver.subscribe(self)
	get_head().subscribe_to()
	get_interaction_controller().canInteract = true
	get_equipment_manager().subscribe_to()
	set_is_running()
	remove_from_group("QueueInputSubscription")

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

func toggle_all_collisions(tog = false):
	$CollisionShape.disabled = tog
	$GroundCheck.enabled = not tog

func unsubscribe_to():
	print("Player unsubscribing")
	Global.InputObserver.unsubscribe(self)
	get_head().unsubscribe_to()
	Global.InputObserver.unsubscribe(get_equipment_manager())
	#Global.InputObserver.unsubscribe(get_interaction_controller())
	get_interaction_controller().canInteract = false
	set_is_running(false)
	print(Global.InputObserver.observers)

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
