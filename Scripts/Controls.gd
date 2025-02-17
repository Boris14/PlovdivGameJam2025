class_name Controls
extends Control

@export var visible_duration := 8.0
@export var fade_out_duration := 2.0

@onready var fade_out_time := fade_out_duration

var is_fading_out := false

func start():
	visible = true
	var fade_out_timer := Timer.new()
	fade_out_timer.timeout.connect(_fade_out_timer_handler)	
	fade_out_timer.wait_time = visible_duration
	add_child(fade_out_timer)
	fade_out_timer.start()

func _ready():
	visible = false
	
func _process(delta):
	if is_fading_out:
		fade_out_time -= delta
		if fade_out_time > 0:
			modulate.a = fade_out_time / fade_out_duration
		else:
			queue_free()


func _fade_out_timer_handler():
	is_fading_out = true
	
