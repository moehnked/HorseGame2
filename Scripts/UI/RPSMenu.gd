extends Control

var horseRef
var playerSelected = 0
var spellRef

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.show_mouse()
	pass # Replace with function body.

func conclude():
	print("RPSMenu: concluding...")
	var hv = horseRef.get_animation_controller().RPSThrown
	print("player: ", playerSelected, " ", stringifySelection(playerSelected), " / ", hv, " ", stringifySelection(hv))
	if playerSelected > hv or (playerSelected == 0 and hv == 2):
		$PlaySound.trigger()
		Global.InteractionPrompt.show_context("You won!")
		pass
	elif playerSelected == hv:
		#tie
		Global.InteractionPrompt.show_context("Tie game...")
		pass
	else:
		var gamePrompt = "Sorry, " + stringifySelection(hv) + " beats " + stringifySelection(playerSelected)
		$PlaySound2.trigger()
		Global.InteractionPrompt.show_context(gamePrompt)
		pass
	spellRef.conclude()
	horseRef.enter_idle()
	queue_free()


func initialize(args = {}):
	args = Utils.check(args, {"horseRef":null, "behaviorRef": null, "spellRef": null})
	horseRef = args["horseRef"]
	Global.Player.get_head().look_at_object(args["horseRef"])
	Global.Player.revoke_menu_options()
	Global.Player.unsubscribe_to()
	spellRef = args["spellRef"]


func shoot_game(val):
	playerSelected = val
	visible = false
	horseRef.get_animation_controller().play_animation("RPS_Shoot")
	var h = Global.Player.get_hand()
	h.set_rps(val, self)
	h.update_sprite("Punch")
	h.play_animation("RPS_Shoot")

func stringifySelection(val):
	match val:
		0:
			return "Shoes"
		1:
			return "Fets"
		2:
			return "Hooves"

func _on_RPSCard_emit_clicked():
	print("selected Shoes")
	shoot_game(0)
	pass # Replace with function body.


func _on_RPSCard2_emit_clicked():
	print("selected Fets")
	shoot_game(1)
	pass # Replace with function body.


func _on_Hooves_emit_clicked():
	shoot_game(2)
	print("selected Hooves")
