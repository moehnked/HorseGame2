extends Area

export(bool) var isActive = false
export(Array, NodePath) var ignoreList

var actor
var dmg = 1

signal is_ready(node)

func _ready():
	emit_signal("is_ready", self)

func _process(delta):
	visible = isActive
	$CollisionShape.disabled = not isActive
	pass # Replace with function body.

func check_ignore(a):
	for i in ignoreList:
		var n = get_node(i)
		if a == n:
			return true
	return false

func initialize(args = {}):
	args= Utils.check(args, {"actor": null, "dmg": 1})
	actor = args["actor"]
	set_damage(args["dmg"])

func get_actor():
	return actor

func set_active(val = true):
	isActive = val

func set_damage(val = 1):
	dmg = val

func _on_ActiveHitBox_area_entered(area):
	if area.has_method("take_damage") and not check_ignore(area):
		area.take_damage(dmg, get_actor())
	pass # Replace with function body.
