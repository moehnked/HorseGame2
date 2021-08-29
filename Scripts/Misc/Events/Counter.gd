extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(int) var count = 0
export(int) var threshold = 1
export(bool) var testGreaterThan = true

func decrement(val = 1):
	count -= val

func increment(val = 1):
	count += val

func test():
	if testGreaterThan:
		if count >= threshold:
			trigger(self)
	else:
		if count <= threshold:
			trigger(self)
