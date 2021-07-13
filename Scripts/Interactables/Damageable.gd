extends Area


export var health = 10

signal damageTaken(dmg, source)
signal destroy()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	emit_signal("destroy")
	queue_free()

func take_damage(dmg = 1, source = null):
	print(dmg, " damage taken")
	health -= dmg
	emit_signal("damageTaken", dmg, source)
	if health <= 0:
		destroy()
