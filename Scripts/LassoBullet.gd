extends KinematicBody

var speed = 60
onready var rope_resource = preload("res://prefabs/LassoBlob.tscn")
onready var rootRef = get_tree().get_root().get_node("World")
var particle_list = []
var can_spawn = true
var power = 1.0
var playerRef
var begun = false

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

func initialize(player, root, palm, callback, hand):
	playerRef = player
	rootRef = root
	playerRef.setLassoLimit()
	playerRef.call(callback)
	global_transform = palm.global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(begun):
		var direction = Vector3() - transform.basis.z
		move_and_slide(direction * speed, Vector3.UP)
		spawn()
	


func _on_RopePartEffect_timeout():
	print("spawn")

	
func spawn():
	if(can_spawn):
		var particle = rope_resource.instance()
		particle.global_transform = global_transform
		rootRef.call_deferred("add_child", particle)
		$RopePartEffect.start()
		particle_list.insert(0, particle)

func collision_effect(collided):
	$TimeToLive.stop()
	if(collided.has_method("lasso")):
		collided.lasso(self)
		playerRef.lasso(collided.saddle)
	deload()
	

func _on_TimeToLive_timeout():
	deload()
	
func deload():
	can_spawn = false
	print("nothing")
	for p in particle_list:
		p.queue_free()
	playerRef.conclude_spell("Lasso")
	queue_free()
	


func _on_milisecondDelay_timeout():
	begun = true
