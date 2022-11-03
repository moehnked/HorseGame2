extends "res://Scripts/Misc/Events/GenericEvent.gd"

export(String) var questID
export(int) var questState
export(String, MULTILINE) var logDescription

func _on_UpdateQuests_emit_event_triggered(by):
	Global.QuestJournal.update_quest(questID, questState, logDescription)
	pass # Replace with function body.
