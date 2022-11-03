extends Node2D

var questAlerts = []

func _ready():
	Global.AlertJournalUpdate = self

func check_alerts():
	if questAlerts.size() > 0:
		visible = true
	else:
		visible = false

func remove_quest_alert(id):
	if questAlerts.has(id):
		questAlerts.erase(id)
	check_alerts()

func set_alert_quests(id):
	if not questAlerts.has(id):
		questAlerts.append(id)
	visible = true
