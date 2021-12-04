extends Control

var glueRef = preload("res://prefabs/Items/Glue.tscn")
var offerOptionRef = preload("res://prefabs/UI/ButcherOfferOption.tscn")
var party = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Player.unsubscribe_to()
	Global.Player.revoke_menu_options()
	Utils.show_mouse()
	Global.InteractionPrompt.hide_center_prompt()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("ui_focus_next"):
		exit_menu()

func exit_menu():
	Global.Player.restore_menu_options()
	Utils.capture_mouse()
	Global.InteractionPrompt.unhide_center_prompt()
	$PlaySound.trigger()
	Global.world.queue_timer(Global.Player, 0.1, "subscribe_to")
	queue_free()

func initialize(args = {}):
	args = Utils.check(args, {"butcherRef":null})
	party = Global.Player.get_party()
	var index = 0
	for i in party:
		print("butcherOffer: ", i.get_horse_name())
		var o = offerOptionRef.instance()
		o.set_name_label(i.get_horse_name())
		o.set_ref(i)
		$Container.add_child(o)
		o.rect_position.y += 50 * index
		o.connect("clicked", self, "process_horse")
		index += 1

func process_horse(selected):
	print("Processing ", selected.get_horse_name())
	Global.Player.remove_from_party(selected)
	var i = selected.get_inventory()
	for n in i:
		n.interact(Global.Player.get_interaction_controller())
	selected.queue_free()
	var num = Global.world.rng.randi_range(1,6)
	for x in num:
		var o = glueRef.instance()
		Global.world.add_child(o)
		o.interact(Global.Player.get_interaction_controller())
	#Global.Player.get_equipment_manager().unequip()
	#Global.Player.subscribe_to()
	exit_menu()
	pass
