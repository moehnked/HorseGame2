extends Spatial

var corrals = []

#get_list_of_points
#get_mid_value
func calculate_midpoint(li = []):
	for i in li:
		print("calculating midpoint..... ", i.name, " - ", i.global_transform.origin)
	return Vector3(get_mid_Value(get_list_of_points(li, "x")), 0.0, get_mid_Value(get_list_of_points(li, "z")))

func get_corral():
	if corrals.size() > 0:
		return corrals[0]

func get_corrals():
	return corrals

func get_list_of_points(li = [], axis = "x"):
	var v = []
	for i in li:
		if(axis == "x"):
			v.append(i.global_transform.origin.x)
		elif axis == "z":
			v.append(i.global_transform.origin.z)
		else:
			print("error: incorrect axis value entered")
			return []
	return v

func get_mid_Value(li = []):
	return li.max() - (float(li.max() - li.min())/2.0)

func register(corral):
	if(!corrals.has(corral)):
		corrals.append(corral)
