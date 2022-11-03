extends Node

export(String) var weatherType = "snow"

var curVal = 0.0
var targetVal = 0.0

func _process(delta):
	curVal = lerp(curVal, targetVal, 0.04)
	if Global.Weather != null:
		Global.Weather.call("update_weather", weatherType, curVal)

func report_distance(val):
	targetVal = val
