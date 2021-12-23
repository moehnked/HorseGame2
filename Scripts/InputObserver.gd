extends Node

#onready var inputMacro = preload("res://Scripts/InputMacro.gd")

var observers = []
var wheel_up = true
var wheel_down = false
var mouse = 0
var mouse_prev = 0
var mouse_sensitivity = 0.08
var controller_sensitivity = 0.03
var mouse_horizontal = 0.0
var mouse_vertical = 0.0
var pauseRef = preload("res://prefabs/UI/PauseMenu.tscn")

var input = InputMacro.new()

func _ready():
	Global.InputObserver = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func clear():
	input = InputMacro.new()
	pass

func subscribe(observer):
	if(!observers.has(observer)):
		observers.append(observer)
	
func unsubscribe(observer):
	observers.erase(observer)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_horizontal = deg2rad(-event.relative.x * mouse_sensitivity)
		mouse_vertical = deg2rad(-event.relative.y * mouse_sensitivity)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			mouse += 1
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			mouse -= 1

func _physics_process(delta):
	input = InputMacro.new()
	
	if(mouse > mouse_prev) or Input.is_action_just_released("ui_up"):
		input.mouse_up = true
		input.mouse_down = false
	elif (mouse < mouse_prev) or Input.is_action_just_released("ui_down"):
		input.mouse_up = false
		input.mouse_down = true
	mouse_prev = mouse
	
	if Input.is_action_just_released("Start"):
		Global.world.instantiate(pauseRef.instance())
	
	if Input.is_action_just_pressed("jump"):
		print("pressed jump")
		input.space = true
		input.direction_detected = true
		
	if Input.is_action_just_released("engage"):
		input.engage = true
	
	if Input.is_action_pressed("special"):
		input.right_mouse_pressed = true
	
	if Input.is_action_just_released("special"):
		input.special = true
		
	if Input.is_action_pressed("standard"):
		input.left_mouse_pressed = true
		
	if Input.is_action_just_released("standard"):
		input.standard = true
	
	if Input.is_action_just_released("OpenInv"):
		input.tab = true
	
	if Input.is_action_pressed("move_forward"):
		input.forward = 1.0
		input.direction_detected = true
	elif Input.is_action_pressed("move_backward"):
		input.backward = 1.0
		input.direction_detected = true
		
	if Input.is_action_pressed("move_left"):
		input.left = 1.0
		input.direction_detected = true
	elif Input.is_action_pressed("move_right"):
		input.right = 1.0
		input.direction_detected = true
	
	mouse_vertical += float(int(Input.is_action_pressed("LookUp")) - int(Input.is_action_pressed("LookDown"))) * controller_sensitivity
	mouse_horizontal += float(int(Input.is_action_pressed("LookLeft")) - int(Input.is_action_pressed("LookRight"))) * controller_sensitivity
	
	input.mouse_horizontal = mouse_horizontal
	input.mouse_vertical = mouse_vertical
	mouse_horizontal = 0.0
	mouse_vertical = 0.0
	
	#print("observers")
	for o in observers:
		#print(o, ", - ", o.name)
		if o == null:
			observers.erase(o)
		else:
			o.parse_input(input)
