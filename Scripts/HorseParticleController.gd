extends Particles
export var ui_time = 2.0

func _ready():
	emitting = false

func loved():
	emitting = true
	amount = 8
	set_positive()
	set_duration_timer()
	
func liked():
	emitting = true
	amount = 2
	set_positive()
	set_duration_timer()
	
func disliked():
	emitting = true
	amount = 2
	set_negative()
	set_duration_timer()
	
func hated():
	emitting = true
	amount = 8
	set_negative()
	set_duration_timer()
	
func set_positive():
	update_mesh("res://Sprites/UI/RE_Plus.png")
	
func set_negative():
	update_mesh("res://Sprites/UI/RE_minus.png")

func update_mesh(path):
	get_draw_pass_mesh(0).surface_get_material(0).albedo_texture = load(path)

func set_duration_timer():
	$ParticleDurationTimer.start(ui_time)
	pass


func _on_ParticleDurationTimer_timeout():
	emitting = false
	pass # Replace with function body.
