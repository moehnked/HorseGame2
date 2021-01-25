extends Control

enum State{fadein, test, fadeout}

export var fadein_rate = 0.03
export var fade_threshold = 0.6

onready var clock_start_pos = $Control/Clock.transform
onready var container_start_pos = $Control.margin_top
onready var completed_start_pos = $Control/completed.margin_top

var callback:String = ""
var check = ""
var completed_index = 0
var completion_interval = 0.0
var dict = ["CANTLE", "GIDDYUP", "DRESSAGE", "YEEHAW", "CHAMPING", "HAY", "PRANCE"]
var fadeout
var horse_ref
var hurry
var jitter_intensity = 1
var kargs = {}
var mistakes = 0
var op = 0.0
var percent_completed = 0.0
var startup_phrase = ""
var state = State.fadein
var time = 4

var sfx_giddyup = "res://sounds/giddyup_01.wav"
var sfx_hurry = "res://sounds/hurry.wav"
var sfx_scratchs = [
	"res://sounds/scratch_00.wav",
	"res://sounds/scratch_01.wav",
	"res://sounds/scratch_02.wav",
	"res://sounds/scratch_03.wav",
	"res://sounds/scratch_04.wav",
	"res://sounds/scratch_05.wav",
	"res://sounds/scratch_06.wav",
	"res://sounds/scratch_07.wav",
]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	startup_phrase = dict[randi() % dict.size()]
	check = startup_phrase.to_lower()
	$Control/Prompt.text = startup_phrase
	$Control/completed.text = startup_phrase
	$Control/completed.percent_visible = 0.0
	completion_interval = 1.0 / startup_phrase.length()
	Global.AudioManager.play_sound(sfx_giddyup)
	hurry = Global.AudioManager.play_sound(sfx_hurry)
	fadeout = Global.AudioManager.play_sound("res://sounds/slowdown.wav")
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

func failed():
	hurry.stop()
	print("FAILURE")
	Global.Player.exit_pilot()
	stopAllTimers()
	$Control/Clock.queue_free()
	state = State.fadeout
	fadeout.stop()
	Global.AudioManager.play_sound("res://sounds/speedup.wav")

func increase_completion():
	$Control/completed.margin_top += 5
	$CorrectEffectTimer.start()
	Global.AudioManager.play_sound(sfx_scratchs[min(completed_index, sfx_scratchs.size()-1)])
	percent_completed += completion_interval
	completed_index += 1
	$Control/completed.percent_visible = percent_completed

func initialize(args = {}):
	print("initializing giddyup challenge")
	args = Utils.check(args, {"horse_ref":null, "callback":"", "kargs":{}})
	horse_ref = args.horse_ref
	callback = args.callback
	kargs = args.kargs

func jitter():
	$Control/Clock.transform = clock_start_pos
	$Control/Clock.translate(jitter_intensity * Vector2(rand_range(0,2),rand_range(0,2)))

func mistake():
	$Control.margin_top += 5
	$MistakeEffectTimer.start()
	$ColorRect.color += Color(0.2,0,0,0)
	mistakes += 1
	if(mistakes == 3):
		failed()

func success():
	hurry.stop()
	print("SUCCESS")
	#horse_ref.tame(Global.Player)
	horse_ref.call(callback, {"tamer":Global.Player})
	#Global.Player.enter_pilot()
	stopAllTimers()
	$Control/Clock.queue_free()
	state = State.fadeout
	fadeout.stop()
	Global.AudioManager.play_sound("res://sounds/speedup.wav")
	
func stopAllTimers():
	$Tik.stop()
	$MistakeEffectTimer.stop()

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
