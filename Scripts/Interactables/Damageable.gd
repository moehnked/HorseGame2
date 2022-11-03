extends Area


export var MaxHP = 10
var health = 10
export(Array, NodePath) var ignorelist = []

var ignore = []

signal damageTaken(dmg, source, damageable)
signal destroy()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_ignore(other):
	ignore.append(other)

func check_ignore(a):
	for i in ignorelist:
		var n = get_node(i)
		if a == n:
			return true
	return false

func destroy():
	emit_signal("destroy")
	queue_free()

func take_damage(dmg = 1, source = null):
	print(dmg, " damage taken", source)
	if not ignore.has(source) and not check_ignore(source):
		health -= dmg
		emit_signal("damageTaken", dmg, source, self)
		if health <= 0:
			destroy()
	else:
		Global.AudioManager.play_sound_3d("res://Sounds/squeak toy - squeak1.wav", -5, global_transform.origin, 3)
