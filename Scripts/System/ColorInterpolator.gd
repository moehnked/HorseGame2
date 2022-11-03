extends Node


export(Curve) var rCurve = Curve.new()
export(Curve) var gCurve = Curve.new()
export(Curve) var bCurve = Curve.new()


func get_color(val, alpha = 1.0):
	val = (float(val % 10)/ 10.0)
	return Color(rCurve.interpolate(val),gCurve.interpolate(val),bCurve.interpolate(val), alpha)
