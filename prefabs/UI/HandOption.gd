extends TextureButton

var spellName
var menuRef
var hand

func initialize(spell, menu, side):
	spellName = spell
	menuRef = menu
	texture_normal = load("res://Sprites/UI/QE_" + spell + ".png")
	hand = side


func _on_TextureButton_button_up():
	menuRef.select_spell(spellName, hand)
