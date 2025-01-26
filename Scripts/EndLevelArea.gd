class_name EndLevelArea
extends Area2D
@onready var wizzard_teleport_sfx: AudioStreamPlayer = $SFX/WizzardTeleportSfx

signal win

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		win.emit()
		wizzard_teleport_sfx.play()
