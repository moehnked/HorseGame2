extends Spatial

var corrals = []

func get_corral():
	if corrals.size() > 0:
		return corrals[0]

func get_corrals():
	return corrals

func register(corral):
	if(!corrals.has(corral)):
		corrals.append(corral)
