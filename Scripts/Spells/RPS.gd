extends Spatial

var callback
var canUpdateTarget = true
var hand
var hasInitialized = false
var lookingat = null
var palm
var source
var spellname = "RPS"

func clear_raycast():
	if lookingat != null:
		lookingat.unhighlight()
		if(canUpdateTarget):
			lookingat = null

func conclude():
	source.conclude_spell("RPS")
	source.restore_menu_options()
	source.subscribe_to()
	source.get_head().unfocus()
	Utils.capture_mouse()
	clear_raycast()
	lookingat = null
	source.raycast_unsubscribe(self)
	Global.InputObserver.unsubscribe(self)
	Global.InteractionPrompt.unhide_center_prompt()
	queue_free()

func initialize(args):
	args = Utils.check(args, {'player':null, 'palm':null, 'callback':null, 'hand':null})
	source = args.player
	hand = args.hand
	palm = args.palm
	callback = args.callback
	subscribe_to()
	source.revoke_menu_options()
	source.raycast_subscribe(self)
	source.revoke_casting()
	$Timer.start(0.1)
	#Global.InteractionPrompt.visible = false
	Global.InteractionPrompt.hide_center_prompt()
	
func subscribe_to():
	Global.InputObserver.subscribe(self)

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

func parse_input(input):
	if input.standard:
		if lookingat != null and hasInitialized:
			canUpdateTarget = false
			print("CLIKCRED RPOS")
			lookingat.call("enter_RPS", {"talkingToController":source.get_interaction_controller(), "spellRef": self})
			unsubscribe_to()
		elif hasInitialized:
			conclude()
		else:
			hasInitialized = true
	if input.mouse_down or input.tab:
		conclude()

func parse_raycast(raycast):
	var col = raycast.get_collider()
	#print(col)
	if col.has_method("highlight"):
		col.highlight()
		#print("lookingat = ", col)
		if(canUpdateTarget):
			lookingat = col
	else:
		clear_raycast()


func _on_Timer_timeout():
	hasInitialized = true
	pass # Replace with function body.
