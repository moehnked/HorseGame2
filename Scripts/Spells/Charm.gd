extends Spatial
var Utils = preload("res://Utils.gd")
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

var callback
var canUpdateTarget = true
var charmStatus:bool = false
var hand
var isCharming = false
var lookingat = null
var palm
var source


func _ready():
	print("Charming")

#this is where the charm we selected from the charm selection wheel returns.
#the selection wheel is cleaned up so we just need to verify the proximity to what the player is lookingat
#and pass that as a target to the soon to be instantiated charm prefab which will do everything it needs to.
#func charm(charm):
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	print("charming with --- ", charm, " - ", lookingat)
#	if(lookingat.has_method("recieve_charm")):
#		if(lookingat.can_be_charmed()):
#			print("sending charm to target ", lookingat)
#			lookingat.recieve_charm(charm, source)
#		else:
#			print("target state: ",lookingat.get_state(), " - target pep: ", lookingat.pep)
#			print("i don't think this horse likes me")
#			Global.InteractionPrompt.show_context("I don't think it wants to talk to me...")
#			Global.AudioManager.play_sound()
#	conclude()

func charm(charm):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("charming with --- ", charm, " - ", lookingat)
	if(lookingat.has_method("recieve_charm")):
		lookingat.recieve_charm(charm, source, self)
		if not charmStatus:
			#print("target state: ",lookingat.get_state(), " - target pep: ", lookingat.pep)
			print("i don't think this horse likes me")
			Global.InteractionPrompt.show_context("I don't think it wants to talk to me...")
			Global.AudioManager.play_sound()
	conclude()

func clear_raycast():
	if lookingat != null:
		lookingat.unhighlight()
		if(canUpdateTarget):
			lookingat = null

func conclude():
	source.conclude_spell("CHARM")
	clear_raycast()
	lookingat = null
	source.raycast_unsubscribe(self)
	queue_free()

func create_charm_wheel():
	var prefab = load("res://prefabs/Spells/CharmSelect.tscn").instance()
	Global.world.call_deferred("add_child", prefab)
	prefab.initialize({'source':source, 'palm':palm, 'callback':"charm", 'charm_origin':self})

func initialize(args):
	args = Utils.check(args, {'player':null, 'palm':null, 'callback':null, 'hand':null})
	source = args.player
	subscribe_to()
	hand = args.hand
	palm = args.palm
	callback = args.callback
	source.raycast_subscribe(self)
	source.revoke_casting()

func parse_input(input):
	if input.standard:
		if lookingat != null:
			canUpdateTarget = false
			create_charm_wheel()
			unsubscribe_to()

func set_status(status = true):
	charmStatus = status

func subscribe_to():
	Global.InputObserver.subscribe(self)

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

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
