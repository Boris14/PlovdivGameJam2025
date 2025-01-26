class_name MainMenu
extends Node2D

@export var game_scene : PackedScene = preload("res://Scenes/Environment/Main.tscn")
@export var music_manager_scene : PackedScene = preload("res://Scenes/MusicManager.tscn")

var music_manager : MusicManager

func _ready():
	music_manager = music_manager_scene.instantiate()
	get_tree().current_scene.add_child(music_manager)
	music_manager.enter_menu()
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/Environment/Main.tscn")
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
