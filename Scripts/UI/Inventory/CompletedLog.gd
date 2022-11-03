extends "res://Scripts/UI/Inventory/Questlog.gd"


func get_active_quest():
	return quests.back()

func get_quests():
	return Utils.reverse(Global.QuestJournal.get_completed_quests())

func get_quest_data(id):
	return Global.QuestJournal.get_completed_quest_data(id)
