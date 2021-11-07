extends Area

export(NodePath) var saddle
export(float) var distThresh = 1.0

enum State {CANLASSO, NOTLASSOABLE, LASSOING, GIDDYUP, PILOT}

signal lassoed(by)

var casterRef = null
var lassoRef = null
var state = State.CANLASSO
var target = null
var rot = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		State.LASSOING:
			casterRef.global_transform.origin = casterRef.global_transform.origin.linear_interpolate(get_node(saddle).global_transform.origin, 0.1)
			if check_distance():
				#lassoRef.deload()
				print("checking if pilotting or giddyup")
				emit_signal("lassoed", casterRef)
			pass
		State.GIDDYUP:
			casterRef.global_transform.origin = get_node(saddle).global_transform.origin
		State.PILOT:
			casterRef.global_transform.origin = get_node(saddle).global_transform.origin
			#casterRef.rotate_y(rot)
			#casterRef.rotation_degrees = target.global_transform.basis.get_euler()
			#casterRef.global_transform.basis = get_node(saddle).global_transform.basis

func check_distance():
	return get_node(saddle).global_transform.origin.distance_to(casterRef.global_transform.origin) < distThresh

func check_hat_level(target):
	var h = casterRef.get_hat().level
	var stats = target.get_stats()
	var largest = stats.values().max()
	return h > largest

func exit_pilot():
	print("lassoable: exiting pilot")
	target.exit_pilot()
	casterRef.exit_pilot(false)
	initialize()

func failed():
	print("lassoable: failed")
	get_parent().call("enter_idle")
	casterRef.exit_pilot()
	state = State.CANLASSO
	if lassoRef != null:
		lassoRef.deload()

func initialize():
	Global.InputObserver.unsubscribe(self)
	state = State.CANLASSO
	casterRef = null
	lassoRef = null
	#target = null

func lasso(other):
	#check if can be lassod
	#if so, start pulling player in
	if state == State.CANLASSO:
		state = State.LASSOING
		lassoRef = other
		casterRef = lassoRef.playerRef

func parse_input(input):
	if input.tab:
		try_exit_pilot()
	rot = input.mouse_horizontal

func start_giddyup(target):
	#check if hat is high enough level
	print("lassoable: checking hat level")
	if check_hat_level(target):
		var challenge = load("res://giddyup_challenge.tscn").instance()
		print("high enough level to lasso")
		state = State.GIDDYUP
		target.enter_giddyup()
		casterRef.set_behavior("Giddyup")
		challenge.initialize({"lassoableRef":self, "callback":"successful_giddyup", "kargs":{"casterRef":casterRef, "target": target}})
		Global.world.call_deferred("add_child", challenge)
	else:
		state = State.CANLASSO

func start_pilot():
	state = State.PILOT
	if target.get_state() != "Pilot":
		target.enter_pilot()
	if casterRef.get_state() != "Pilot":
		casterRef.enter_pilot()
		
	casterRef.rotation_degrees.y = target.rotation_degrees.y
	Global.InputObserver.subscribe(self)
	if lassoRef != null:
		lassoRef.deload()

func stop():
	#lassoRef.deload()
	pass

func successful_giddyup(args = {}):
	args = Utils.check(args, {"target": null})
	target = args.target
	target.tame({"tamer": casterRef})
	start_pilot()
	#casterRef.enter_pilot()
	pass

func try_exit_pilot():
	if target.trainer.can_exit_horse():
		print("lassoable: exiting pilot")
		exit_pilot()
