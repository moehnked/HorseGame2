extends Spatial

export(float) var minimum = 0.0
export(bool) var skipReporting = false
export(String) var targetGroup = ""
export(NodePath) var targetNode
export(String) var triggeringGroup = ""
export(NodePath) var triggeringNode

var reportClear = false
var reporting = false
var reportTarget

signal emit_target_entered()
signal emit_target_exited()

func _process(delta):
	if not skipReporting:
		if reporting:
			print("reporting")
			report(check_dist(reportTarget.global_transform.origin))
			reportClear = true
		elif reportClear:
			reportClear = false
			report(0.0)
		

func check_dist(otherPos):
	return clamp(1 - ((otherPos.distance_to(global_transform.origin) - minimum) /scale.length()), 0.0, 1.0)
	pass

func check_if_target(other):
	var x = get_node(triggeringNode) == other or other.is_in_group(triggeringGroup)
	if x:
		reportTarget = other
	return x

func report(val):
	get_tree().call_group(targetGroup, "report_distance", val)
	var n = get_node(targetNode)
	if n != null:
		n.call("report_distance", val)
	pass

func _on_ReportProximity_body_entered(body):
	reporting = check_if_target(body)
	if reporting:
		emit_signal("emit_target_entered")
	pass # Replace with function body.


func _on_ReportProximity_body_exited(body):
	if check_if_target(body):
		if body.has_method("is_collision_enabled"):
			if not body.is_collision_enabled():
				return
		reporting = false
		emit_signal("emit_target_exited")
	pass # Replace with function body.
