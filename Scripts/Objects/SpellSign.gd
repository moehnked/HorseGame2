extends "res://Scripts/Objects/Sign.gd"


export(String) var spell = "Null"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpellSign_sign_read(controller):
	if not Global.Player.get_spell_list().has(spell):
		Global.Player.spellList.append(spell)
		Global.world.instantiate("res://prefabs/Effects/TrophyShatter.tscn", global_transform.origin + Vector3(0,0.5,0))
		Global.InteractionPrompt.show_context("You have learned the spell: " + spell)
		queue_free()
	pass # Replace with function body.
