extends Control

var initargs = {}
var sfx = {
	"open":preload("res://Sounds/UI_Open_02.wav"),
	"close":preload("res://Sounds/UI_Close_02.wav")
}
var canSelectJournal = true
var containerStarPos
var selected_journal
var target_journal_focus_pos
var target_bg_rotation = 23


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Global.AudioManager.play_sound(sfx["open"])
	containerStarPos = $JournalContainer.position
	target_journal_focus_pos = containerStarPos
	selected_journal = $JournalContainer/QuestlogButton
	#$JournalMenuContainer/JournalListItem.grab_focus()
	$JournalContainer/QuestlogButton.grab_focus()
	$JournalContainer/QuestlogButton.press()
	Utils.show_mouse(true)
	
	pass

func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		deload()
	
	$JournalContainer.position = $JournalContainer.position.linear_interpolate(target_journal_focus_pos, 5 * delta)
	$Container/Journal_Ornament.rotation_degrees = lerp($Container/Journal_Ornament.rotation_degrees, target_bg_rotation, 2 * delta)

func deload():
	Global.AudioManager.play_sound(sfx["close"])
	get_tree().paused = false
	Utils.capture_mouse()
	initargs.source.call(initargs.callback)
	queue_free()

func initialize(args = {}):
	initargs = Utils.check(args, {'source':self, 'callback':"exit_inventory"})

func parse_journal_selection(listItem):
	if canSelectJournal:
		canSelectJournal = false
		$ContainerAnimator.stop(true)
		for c in $JournalMenuContainer.get_children():
			$JournalMenuContainer.remove_child(c)
			c.queue_free()
		var j = listItem.get_journal().instance()
		$JournalMenuContainer.add_child(j)
		$ContainerAnimator.play("default")

func update_journal_focus(btn):
	if btn != selected_journal:
		selected_journal = btn
		target_journal_focus_pos = containerStarPos - btn.rect_position
		target_bg_rotation = 23 + (btn.get_index() * 90)
		Global.AudioManager.play_sound("res://Sounds/tumbler_01.wav", -4)
	
