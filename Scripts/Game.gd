class_name Game
extends Node2D

@export var player_scene : PackedScene = preload("res://Scenes/Player.tscn")
@export var wizard_scene : PackedScene = preload("res://Scenes/Wizard.tscn")
@export var wizard_x_offset := 110
@export var start_delay := 1.5
@export var music_manager_scene : PackedScene = preload("res://Scenes/MusicManager.tscn")
@export var next_level_index := -1

var music_manager : MusicManager

@onready var hud := %HUD as HUD
@onready var end_area := $EndLevelArea
@onready var boss := $Boss as Boss
@onready var controls := $CanvasLayer/Controls as Controls

var wizard

func _ready():
	if boss != null:
		boss.win_game.connect(_on_win)
		
	hud.visible = false
	music_manager = music_manager_scene.instantiate()
	get_tree().current_scene.add_child(music_manager)
	music_manager.start_game()
	
	var player = player_scene.instantiate() as Player
	player.died.connect(_on_player_died)
	player.position = %PlayerStart.position
	add_child(player)
	
	if next_level_index == -1:
		music_manager.boss_enter()
	
	if end_area != null:
		end_area.win.connect(_on_level_finish)
	
	await get_tree().create_timer(start_delay).timeout
	
	if controls != null:
		controls.start()
	
	player.can_move = true
	
	wizard = wizard_scene.instantiate() as Wizard
	wizard.global_position.y = get_global_mouse_position().y
	wizard.global_position.x = wizard_x_offset
	wizard.bubble_type_changed.connect(_on_bubble_type_changed)
	add_child(wizard)
	
func _on_player_died():
	get_tree().reload_current_scene()
	
func _on_level_finish():
	wizard.teleport()
	music_manager.level_transition(_on_win_sound_finished)

func _on_win():
	music_manager.win_game(null)
	await get_tree().create_timer(3.0).timeout
	_on_win_sound_finished()
	
func _on_win_sound_finished():
	match(next_level_index):
		1:
			get_tree().change_scene_to_file("res://Scenes/Environment/Main2.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/Environment/Main3.tscn")
		3:
			get_tree().change_scene_to_file("res://Scenes/Environment/Main4.tscn")
		4:
			get_tree().change_scene_to_file("res://Scenes/Environment/Main5.tscn")
		_:
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _on_bubble_type_changed(new_type: Wizard.EBubbleType, unlocked_bubble_types : Array[Wizard.EBubbleType]):
	if hud != null:
		hud.visible = true
		hud.set_bubble_type(new_type, unlocked_bubble_types)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
