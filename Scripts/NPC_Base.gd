extends Spatial

export(Resource) var dialogicScreen
export(int) var dialoguePoint
export(String) var npcName
export(Array, Resource) var sfx
export(float) var speakingVolume = 0.0

signal emit_dialogue_exit()

func exit_dialogue():
	emit_signal("emit_dialogue_exit")
	pass

func get_dialogue_point():
	return npcName + "/" + (("0" + String(dialoguePoint)) if dialoguePoint < 10 else String(dialoguePoint))

func get_speaking_volume():
	return speakingVolume
	pass

func get_talk_sfx():
	return Utils.get_random(sfx)

func increment_timeline():
	dialoguePoint += 1

func start_talking(controller):
	var ds = dialogicScreen.instance()
	Global.world.add_child(ds)
	ds.initialize({'speaker':self, 'listener':controller.get_parent(), 'text':["hellow", "world"], "timelineName":get_dialogue_point()})
	controller.begin_dialogue(self)

