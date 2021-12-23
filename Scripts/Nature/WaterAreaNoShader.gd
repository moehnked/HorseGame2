extends Area

#{body : contactPosition}
var bodiesInWater = {}
var effectResource = preload("res://prefabs/Effects/Ripple.tscn")
var ripplePool = []
var ripplesInUse = []
var offsetV = Vector3.ZERO

export(Array, Resource) var fishableItems = []
export(Curve) var distribution
export var MAXRIPPLES = 25

func _ready():
	for i in range(MAXRIPPLES):
		var r = effectResource.instance()
		ripplePool.append(r)
		add_child(r)
		r.connect("emit_effect_end", self, "queue_ripple_end")
	pass

func _process(delta):
	check_movement()

func check_move_helper(b):
	var point = b.global_transform.origin
	point.y = bodiesInWater[b].y
	if bodiesInWater[b].distance_to(point) > 1.4:
		bodiesInWater[b] = point
		return true
	else:
		return false

func check_movement():
	for b in bodiesInWater.keys():
		if check_move_helper(b):
			var np = b.global_transform.origin
			#bodiesInWater[b] = Vector3(np.x, bodiesInWater[b].y, np.z)
			make_ripple(b)

func get_fishable_item():
	for x in range(fishableItems.size()):
		var roll = Utils.get_rng().randf_range(0.0,1.0)
		if roll <= distribution.interpolate(float(x) / float(fishableItems.size())):
			return fishableItems[x]
	return get_fishable_item()

func is_water():
	return true

func make_ripple(b, scaleMod = 1.0):
	if ripplePool.size() > 0:
		var r = ripplePool.pop_front()
		r.global_transform.origin = bodiesInWater[b]
		r.scale *= scaleMod
		r.start()

func make_splash(b, scaleMod = 1.0):
	$BigSplash.global_transform.origin = b.global_transform.origin - Vector3(0,1,0)
	$BigSplash.scale *= scaleMod
	$BigSplash.isEmitting = true
	

func queue_ripple_end(r):
	ripplePool.append(r)

func _on_WaterAreaNoShader_body_entered(body):
	#if body.scale.length() > 0.2:
	bodiesInWater[body] = body.global_transform.origin
	bodiesInWater[body].y = global_transform.origin.y
	make_ripple(body, body.call("get_splash_scale") if body.has_method("get_splash_scale") else 1.0)
	if not body.is_in_group("ignoreSplash"):
		$Splash.trigger()
		make_splash(body, body.call("get_splash_scale") if body.has_method("get_splash_scale") else 1.0)
		$Droplets.initialize(body.global_transform.origin)
	if body.has_method("enter_water"):
		body.call("enter_water", self)
	pass # Replace with function body.

func _on_WaterAreaNoShader_body_exited(body):
	bodiesInWater.erase(body)
	pass # Replace with function body.
