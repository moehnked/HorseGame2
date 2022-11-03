extends Control

var questlogOptionRef = preload("res://prefabs/UI/InventoryScreens/QuestlineOption.tscn")
var promptRef = preload("res://prefabs/UI/InventoryScreens/QuestPrompt.tscn")
onready var quests = get_quests()

func _ready():
	var count = 0
	for c in quests:
		var o = questlogOptionRef.instance()
		$QuestsContainer.add_child(o)
		o.rect_position.y += 92 * count
		o.connect("emit_pressed", self, "update_selection")
		o.questID = c
		o.modulate = Color(1,1,1,1) - $ColorInterpolator.get_color(count, 0.0)
		count += 1
	if count > 0:
		update_selection(get_active_quest())

func clear_selection():
	for c in $ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
		$ScrollContainer/VBoxContainer.remove_child(c)

func get_active_quest():
	return Global.QuestJournal.active_quest_id()

func get_quests():
	return Global.QuestJournal.get_quests()

func get_quest_data(id):
	return Global.QuestJournal.get_quest(id)

func play_sound():
	Global.AudioManager.play_sound("res://Sounds/shift_02.wav", -2)

func update_selection(id):
	clear_selection()
	var q = get_quest_data(id)
	for c in Utils.reverse(q.prompts):
		var l = promptRef.instance()
		l.initialize({"text": c, "completed": not (c == q.prompts.back())})
		$ScrollContainer/VBoxContainer.add_child(l)
	$Questname.text = Global.QuestJournal.get_quest_name(id)
	Global.AlertJournalUpdate.remove_quest_alert(id)
	print(id)
