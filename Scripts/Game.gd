class_name Game
extends Node2D

@export var next_level_scene : PackedScene
@export var player_scene : PackedScene = preload("res://Scenes/Player.tscn")
@export var wizard_scene : PackedScene = preload("res://Scenes/Wizard.tscn")
@export var wizard_x_offset := 90
@export var start_delay := 1.5
@export var music_manager_scene : PackedScene = preload("res://Scenes/MusicManager.tscn")

var music_manager : MusicManager

@onready var hud := %HUD as HUD
@onready var end_area := $EndLevelArea

func _ready():
	music_manager = music_manager_scene.instantiate()
	get_tree().current_scene.add_child(music_manager)
	music_manager.start_game()
	
	var player = player_scene.instantiate() as Player
	player.died.connect(_on_player_died)
	player.position = %PlayerStart.position
	add_child(player)
	
	if end_area != null:
		end_area.win.connect(_on_win)
	
	await get_tree().create_timer(start_delay).timeout
	
	player.can_move = true
	
	var wizard = wizard_scene.instantiate() as Wizard
	wizard.global_position.y = get_global_mouse_position().y
	wizard.global_position.x = wizard_x_offset
	wizard.bubble_type_changed.connect(_on_bubble_type_changed)
	add_child(wizard)
	
func _on_player_died():
	get_tree().reload_current_scene()
	
func _on_win():
	#music_manager.win_game(_on_win_sound_finished)
	music_manager.level_transition(_on_win_sound_finished)
	
func _on_win_sound_finished():
	if next_level_scene != null:
		get_tree().call_deferred("change_scene_to_packed", next_level_scene)
	else:
		get_tree().call_deferred("reload_current_scene")
	
func _on_bubble_type_changed(new_type: Wizard.EBubbleType, unlocked_bubble_types : Array[Wizard.EBubbleType]):
	if hud != null:
		hud.set_bubble_type(new_type, unlocked_bubble_types)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
