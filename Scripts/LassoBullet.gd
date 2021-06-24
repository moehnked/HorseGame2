extends Area
var Utils = preload("res://Utils.gd")

var speed = 40
onready var rope_resource = preload("res://prefabs/LassoBlob.tscn")
var particle_list = []
var can_spawn = true
var power = 1.0
var playerRef
var begun = false
var lassoSucceeded = false

var sound_paths = [
	"res://sounds/lasso_01.wav",
	"res://sounds/lasso_02.wav",
	"res://sounds/lasso_03.wav",
	"res://sounds/lasso_04.wav",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var sfx = sound_paths[randi() % sound_paths.size()]
	$AudioStreamPlayer.stream = load(sfx)
	$AudioStreamPlayer.play()
	$milisecondDelay.start()
	pass # Replace with function body.

func initialize(args):
	var kargs = Utils.check(args, {'player':null, 'palm':null, 'callback':null, 'hand':null})
	playerRef = kargs['player']
	playerRef.setLassoLimit()
	playerRef.call(kargs['callback'])
	global_transform = kargs['palm'].global_transform
	#linear_velocity = Vector3() - transform.basis.z * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(begun):
		var direction = Vector3() - transform.basis.z
		#move_and_slide(direction * speed, Vector3.UP)
		global_transform.origin += direction * speed * delta
		spawn()


func _on_RopePartEffect_timeout():
	print("spawn")

	
func spawn():
	if(can_spawn):
		var particle = rope_resource.instance()
		particle.global_transform = global_transform
		Global.world.call_deferred("add_child", particle)
		$RopePartEffect.start()
		particle_list.insert(0, particle)

func collision_effect(collided):
	$TimeToLive.stop()
	if(collided.has_method("lasso")):
		if(collided.can_be_lassod()):
			print("EXECUTING LASSO")
			collided.lasso(self)
			playerRef.lasso(collided.get_saddle(), self)
		else:
			Global.AudioManager.play_sound()
	deload()
	
	
func deload():
	can_spawn = false
	print("nothing")
	for p in particle_list:
		p.queue_free()
	playerRef.conclude_spell("Lasso")
	queue_free()

func _on_TimeToLive_timeout():
	deload()

func _on_milisecondDelay_timeout():
	begun = true


func _on_LassoBullet_body_entered(body):
	collision_effect(body)
	pass # Replace with function body.
