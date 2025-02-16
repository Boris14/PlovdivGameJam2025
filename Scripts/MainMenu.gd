class_name MainMenu
extends Node2D

@export var game_scene : PackedScene = preload("res://Scenes/Environment/Main.tscn")
@export var music_manager_scene : PackedScene = preload("res://Scenes/MusicManager.tscn")
@export var menu_delay := 0.3
@export var cat_rotation_rate := 5.0
@export var cat_max_rotation := 5
@export var fade_in_rate := 0.5

var music_manager : MusicManager
var take_input := false
var current_image_index := 0
var images : Array[Node]
var rotation_direction := 1

func _ready():
	images = $CanvasLayer.get_children()
	for image in images:
		image.visible = false
	images[0].visible = true
	
	$CanvasLayer/Intro3.modulate.a = 0
	
	music_manager = music_manager_scene.instantiate()
	get_tree().current_scene.add_child(music_manager)
	music_manager.enter_menu()
	
	await get_tree().create_timer(menu_delay).timeout
	take_input = true
	
func _process(delta):
	if current_image_index == 1:
		$CanvasLayer/Intro1.rotation_degrees += rotation_direction * cat_rotation_rate * delta
		if $CanvasLayer/Intro1.rotation_degrees > cat_max_rotation and rotation_direction > 0:
			rotation_direction = -1
		elif $CanvasLayer/Intro1.rotation_degrees < -cat_max_rotation and rotation_direction < 0:
			rotation_direction = 1
	elif current_image_index == 3:
		if $CanvasLayer/Intro3.modulate.a < 1:
			$CanvasLayer/Intro3.modulate.a += fade_in_rate * delta
		
func _input(event):
	if not take_input:
		return
	if event is InputEventMouseButton and event.is_pressed():
		go_to_next_screen()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
func go_to_next_screen():
	current_image_index += 1
	match(current_image_index):
		1:
			for image in images:
				image.visible = false
			images[1].visible = true
		2:
			for image in images:
				image.visible = false
			images[2].visible = true
		3:
			images[3].visible = true
		4:
			for image in images:
				image.visible = false
			images[4].visible = true
		5:
			get_tree().change_scene_to_file("res://Scenes/Environment/Main.tscn")
	
	if current_image_index < 5:
		await get_tree().create_timer(menu_delay).timeout
		take_input = true
	
