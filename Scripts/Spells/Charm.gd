extends Spatial
const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

var playerRef
var rootRef
var _callback
var _hand
var _palm
var lookingat = null
var isCharming = false
var canUpdateTarget = true

func _ready():
	print("Charming")

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)
	
func initialize(player, root, palm, callback, hand):
	playerRef = player
	rootRef = root
	subscribe_to()
	_hand = hand
	_palm = palm
	_callback = callback
	playerRef.raycast_subscribe(self)
	playerRef.revoke_casting()

#this is where the charm we selected from the charm selection wheel returns.
#the selection wheel is cleaned up so we just need to verify the proximity to what the player is lookingat
#and pass that as a target to the soon to be instantiated charm prefab which will do everything it needs to.
func charm(charm):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("charming with --- ", charm, " - ", lookingat)
	if(lookingat.has_method("recieve_charm")):
		print("sending charm to target ", lookingat)
		lookingat.recieve_charm(charm, playerRef)
	conclude()

func conclude():
	playerRef.conclude_spell("CHARM")
	clear_raycast()
	lookingat = null
	playerRef.raycast_unsubscribe(self)
	queue_free()

func parse_input(input):
	if input.standard:
		if lookingat != null:
			canUpdateTarget = false
			create_charm_wheel()
			unsubscribe_to()

func create_charm_wheel():
	var prefab = load("res://prefabs/Spells/CharmSelect.tscn").instance()
	rootRef.call_deferred("add_child", prefab)
	prefab.initialize(playerRef, rootRef, _palm, "charm", _hand, self)
	

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

func clear_raycast():
	if lookingat != null:
		#print("lookingat = null")
		lookingat.unhighlight()
		if(canUpdateTarget):
			lookingat = null
