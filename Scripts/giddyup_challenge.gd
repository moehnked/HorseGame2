extends Control



enum State{fadein, test, fadeout}
var state = State.fadein
var op = 0.0
export var fadein_rate = 0.03
export var fade_threshold = 0.6
var dict = ["CANTLE", "NICKER", "DRESSAGE", "YEEHAW", "CHAMPING", "HAY", "PRANCE"]
var startup_phrase = ""
var check = ""
var jitter_intensity = 1
onready var clock_start_pos = $Control/Clock.transform
onready var container_start_pos = $Control.margin_top
onready var completed_start_pos = $Control/completed.margin_top
var completion_interval = 0.0
var percent_completed = 0.0
var completed_index = 0
var mistakes = 0
var player_ref
var horse_ref
var time = 4
var sfx_beats = [
	"res://sounds/beat_01.wav",
	"res://sounds/beat_02.wav",
	"res://sounds/beat_03.wav",
	"res://sounds/beat_04.wav",
	"res://sounds/beat_05.wav",
	"res://sounds/beat_06.wav",
	"res://sounds/beat_07.wav",
]
onready var sfx_giddyup = preload("res://sounds/giddyup_01.wav")
onready var sfx_hurry = preload("res://sounds/hurry.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	startup_phrase = dict[randi() % dict.size()]
	check = startup_phrase.to_lower()
	$Control/Prompt.text = startup_phrase
	$Control/completed.text = startup_phrase
	$Control/completed.percent_visible = 0.0
	completion_interval = 1.0 / startup_phrase.length()
	$AudioStreamPlayer.stream = sfx_giddyup
	$AudioStreamPlayer.play()
	$Hurry.stream = sfx_hurry
	$Hurry.play()
	$FadeSound.stream = load("res://sounds/slowdown.wav")
	$FadeSound.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.fadein:
			fadeIn()
		State.test:
			jitter()
		State.fadeout:
			fadeOut()
			
func _input(ev):
	if state == State.test:
		if ev is InputEventKey and not ev.echo and ev.pressed:
			if((ev.unicode >= 97) and (ev.unicode <= 122)):
				var key = char(ev.unicode)
				print(key)
				print(check, " - ", check[completed_index])
				if(key == check[completed_index]):
					increase_completion()
					if(completed_index == check.length()):
						success()
				else:
					mistake()
					
func mistake():
	$Control.margin_top += 5
	$MistakeEffectTimer.start()
	$ColorRect.color += Color(0.2,0,0,0)
	mistakes += 1
	if(mistakes == 3):
		failed()

func failed():
	$Hurry.stop()
	print("FAILURE")
	player_ref.exit_pilot()
	stopAllTimers()
	$Control/Clock.queue_free()
	state = State.fadeout
	$FadeSound.stop()
	$FadeSound.stream = load("res://sounds/speedup.wav")
	$FadeSound.play()

func success():
	$Hurry.stop()
	print("SUCCESS")
	horse_ref.tame(player_ref)
	stopAllTimers()
	$Control/Clock.queue_free()
	state = State.fadeout
	$FadeSound.stop()
	$FadeSound.stream = load("res://sounds/speedup.wav")
	$FadeSound.play()
	
func stopAllTimers():
	$Tik.stop()
	$MistakeEffectTimer.stop()
	
func fadeIn():
	op += fadein_rate
	$ColorRect.set_frame_color($ColorRect.color + Color(0,0,0,fadein_rate))
	if(op > fade_threshold):
		$Control.visible = true
		state = State.test
		$Tik.start()
		
func fadeOut():
	op -= fadein_rate
	$ColorRect.set_frame_color($ColorRect.color - Color(0,0,0,fadein_rate))
	if(op < 0):
		queue_free()

func jitter():
	$Control/Clock.transform = clock_start_pos
	$Control/Clock.translate(jitter_intensity * Vector2(rand_range(0,2),rand_range(0,2)))
	
func increase_completion():
	$Control/completed.margin_top += 5
	$CorrectEffectTimer.start()
	$AudioStreamPlayer.stream = load(sfx_beats[min(completed_index, sfx_beats.size()-1)])
	$AudioStreamPlayer.play()
	percent_completed += completion_interval
	completed_index += 1
	$Control/completed.percent_visible = percent_completed

func _on_Tik_timeout():
	$Control/Clock.frame += 1
	time -= 1
	jitter_intensity += 2
	if(time == 0):
		failed()
	else:
		$Tik.start()
	


func _on_MistakeEffectTimer_timeout():
	$Control.margin_top = container_start_pos


func _on_CorrectEffectTimer_timeout():
	$Control/completed.margin_top = completed_start_pos
