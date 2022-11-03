extends Area

var speed = 40
var particle_list = []
var can_spawn = true
var power = 1.0
var playerRef
var begun = false
var lassoSucceeded = false

var lassoBlob = preload("res://prefabs/Spells/LassoBlob.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Lasso: Ready")
	$PlaySound.trigger()
	$milisecondDelay.start()
	$TTL.start()
	pass # Replace with function body.

func initialize(args):
	var kargs = Utils.check(args, {'player':null, 'palm':null, 'callback':null, 'hand':null})
	playerRef = kargs['player']
	playerRef.set_lasso_limit()
	playerRef.call(kargs['callback'])
	global_transform = kargs['palm'].global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(begun):
		var direction = Vector3() - transform.basis.z
		global_transform.origin += direction * speed * delta
		spawn()


func _on_RopePartEffect_timeout():
	print("Lasso: spawn")

	
func spawn():
	if(can_spawn):
		var particle = lassoBlob.instance()
		particle.global_transform = global_transform
		Global.world.call_deferred("add_child", particle)
		$RopePartEffect.start()
		particle_list.insert(0, particle)

func collision_effect(collided):
	$TTL.stop()
	if(collided.has_method("lasso")):
		collided.lasso(self)
		speed = 0
		deload()
	
	
func deload():
	print("Lasso: deload")
	can_spawn = false
	for p in particle_list:
		p.queue_free()
	playerRef.conclude_spell("Lasso")
	queue_free()


func _on_milisecondDelay_timeout():
	print("Lasso: Milisecond")
	begun = true
	#$TTL.start()


func _on_LassoBullet_body_entered(body):
	collision_effect(body)
	deload()
	pass # Replace with function body.


func _on_LassoBullet_area_entered(area):
	collision_effect(area)
	pass # Replace with function body.
