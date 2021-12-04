extends TextureButton

var spellName
var menuRef
var hand

func initialize(spell, menu, side):
	spellName = spell
	menuRef = menu
	texture_normal = menu.spellIcons[spell]
	hand = side

func engage():
	menuRef.select_spell(spellName, hand)
	get_tree().call_group("UI_Event", "trigger", self)

func get_spell_name():
	return spellName

func _on_TextureButton_button_up():
	engage()
