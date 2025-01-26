class_name Spikes
extends Area2D

@onready var fall_on_needles_sfx: AudioStreamPlayer = $SFX/FallOnNeedlesSfx

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		fall_on_needles_sfx.play()
		body.call_deferred("die")
	elif body is Bubble:
		body.pop()
