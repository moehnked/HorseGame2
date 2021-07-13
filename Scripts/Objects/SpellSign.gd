extends "res://Scripts/Objects/Sign.gd"


export(String) var spell = "Null"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_context():
	return "You have learned the spell: " + spell

func read_sign(controller):
	if not Global.Player.get_spell_list().has(spell):
		Global.Player.spellList.append(spell)
	Global.world.instantiate("res://prefabs/Effects/TrophyShatter.tscn", global_transform.origin + Vector3(0,0.5,0))
	Global.AudioManager.play_sound("res://Sounds/Special_" + String(Global.world.rng.randi_range(1,5)) + ".wav")
	queue_free()

func _on_SpellSign_sign_read(controller):
	read_sign(controller)
	pass # Replace with function body.
