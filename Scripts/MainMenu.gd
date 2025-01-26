class_name MainMenu
extends Node2D

@export var game_scene : PackedScene = preload("res://Scenes/Environment/Main.tscn")
@export var music_manager_scene : PackedScene = preload("res://Scenes/MusicManager.tscn")
@export var menu_delay := 0.3

var music_manager : MusicManager
var take_input := false

func _ready():
	music_manager = music_manager_scene.instantiate()
	get_tree().current_scene.add_child(music_manager)
	music_manager.enter_menu()
	
	await get_tree().create_timer(menu_delay).timeout
	take_input = true
	
	
func _input(event):
	if not take_input:
		return
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/Environment/Main.tscn")
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
