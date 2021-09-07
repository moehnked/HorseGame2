extends "res://Scripts/UI/Dialogue/DialogueOption.gd"

var i = 0
export(Array, String) var lines = ["hello world"]
export(Array, Resource) var nextOptions = []
export(bool) var sfxOnEachLine = false
export(bool) var copyCurrentOptions = false
#export(Array, Resource) var removeResources = []
export(bool) var removeSelfFromCopy = false

signal emit_end_of_lines()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func close():
	emit_signal("emit_end_of_lines")

func remove_self_from_current_options(no):
	print("DO Talk: checking self in options to be removed...")
	for a in no:
		if resPath == a.resource_path:
			print("DO Talk: erasing copy of self from options")
			no.erase(a)
	return no
	pass

func trigger():
	print("DA Talk: YOU SELECTED TALK MOTHERFUCKER - ", i)
	var ds = initArgs["ds"]
	if ds != null:
		if ds.has_method("start_talking"):
			ds.set_text(lines[i])
			ds.call("start_talking")
			i += 1
			print("DA Talk: start talking ", i)
			if i > lines.size() - 1:
				var no = []
				if copyCurrentOptions:
					#print("DA Talk: copying options...")
					no = ds.speaker.get_options()
					no.pop_back()
					for k in no:
						var kpath = k.resource_path
						#print("DA Talk: ", kpath)
						for ops in nextOptions:
							#print("DA Talk: nextOps paths: ", ops.resource_path)
							if kpath == ops.resource_path:
								print("COPY FOUNBD!!!!!!")
								no.erase(k)
				if removeSelfFromCopy:
#						for a in no:
#							if resPath == a.resource_path:
#								no.erase(a)
					no = remove_self_from_current_options(no)
				no += nextOptions
				ds.speaker.set_options(no)
			else:
				print("talk:  more lines")
			pass
#
#func trigger():
#	print("DA Talk: YOU SELECTED TALK MOTHERFUCKER - ", i)
#	var ds = initArgs["ds"]
#	if ds != null:
#		if ds.has_method("start_talking"):
#			ds.set_text(lines[i])
#			ds.call("start_talking")
#			i += 1
#			print("DA Talk: start talking ", i)
#			if i > lines.size() - 1:
#				#emit_signal("emit_end_of_lines")
#				if nextOptions.size() > 0:
#					print("DA Talk: loading next options")
#					var no = []
#					if copyCurrentOptions:
#						#print("DA Talk: copying options...")
#						no = ds.speaker.get_options()
#						no.pop_back()
#						for k in no:
#							var kpath = k.resource_path
#							#print("DA Talk: ", kpath)
#							for ops in nextOptions:
#								#print("DA Talk: nextOps paths: ", ops.resource_path)
#								if kpath == ops.resource_path:
#									print("COPY FOUNBD!!!!!!")
#									no.erase(k)
#					if removeSelfFromCopy:
##						for a in no:
##							if resPath == a.resource_path:
##								no.erase(a)
#						no = remove_self_from_current_options(no)
#					no += nextOptions
#					ds.speaker.set_options(no)
#			else:
#				print("talk:  more lines")
#			pass

func _on_Talk_emit_selected():
	trigger()
	pass # Replace with function body.
