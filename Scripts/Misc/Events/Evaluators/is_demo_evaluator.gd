extends "res://Scripts/Misc/Events/Evaluators/evaluator.gd"

static func evaluate(args = {}):
	return int(Dialogic.get_variable("isDemo")) > 0
