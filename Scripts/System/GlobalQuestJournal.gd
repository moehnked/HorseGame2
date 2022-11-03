extends Node

var activeQuest = null
var completed_file = "user://completedquests.json"
var completedQuests = {}
var questlog_file = "user://questlog.json"
var questlog = {}

var questNames = {
	"_A1": "Learning The Ropes",
	"_A2": "How To Make Friends",
	"_A3": "A License To Build",
	"_A4": "The Means To Unbuild",
	"_Test": "Test Questline"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.QuestJournal = self
	load_save()
	pass # Replace with function body.

func active_quest_id():
	if activeQuest == null:
		set_active(questlog.keys().front())
	return activeQuest

func complete_quest(id):
	update_quest(id, get_quest(id)["state"] + 1, "[COMPLETED]")
	completedQuests[id] = questlog[id]
	questlog.erase(id)
	if id == activeQuest:
		activeQuest = null
	save_logs()

func get_active_quest():
	if activeQuest == null:
		set_active(questlog.keys().front())
	return questlog[activeQuest]

func get_completed_quests():
	return completedQuests.keys()

func get_completed_quest_data(id):
	return completedQuests[id]

func get_quest(questid):
	return questlog[questid]

func get_quests():
	return questlog.keys()

func get_quest_name(id):
	return questNames[id]

func load_save():
	#save active questlog
	var file = File.new()
	if file.file_exists(questlog_file):
		file.open(questlog_file, File.READ)
		questlog = parse_json(file.get_line())
	#save completed quests
	file = File.new()
	if file.file_exists(completed_file):
		file.open(completed_file, File.READ)
		completedQuests = parse_json(file.get_line())

func save_logs():
	#save active questlog
	var file = File.new()
	file.open(questlog_file, File.WRITE)
	file.store_line(to_json(questlog))
	#save completed quests
	file = File.new()
	file.open(completed_file, File.WRITE)
	file.store_line(to_json(completedQuests))

func set_active(questid):
	activeQuest = questid

func update_quest(questid, state, prompt):
	set_active(questid)
	if questlog.keys().has(questid):
		questlog[questid].state = max((0 if questlog[questid].state == null else questlog[questid].state),state)
		if questlog[questid].prompts.size() > state:
			questlog[questid].prompts[state] = prompt
		else:
			questlog[questid].prompts.append(prompt)
	else:
		questlog[questid] = {
			"state": state,
			"prompts": [prompt]
		}
	Global.AlertJournalUpdate.set_alert_quests(questid)
	save_logs()
	pass
