class_name MusicManager
extends Node

func set_bus_volume(bus_name : String, volume: float):
	var index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(index, volume)

func enter_menu():
	$MenuMusic.play()
	
func start_game():
	$MainMusic.play()
	$MainAmbient.play()
	$MainMusicAddPercussion.play()
	$MainMusicAddPercussion.volume_db = -80
	#set_bus_volume("Percussion", -80.0)
	
func boss_enter():
	$MainMusicAddPercussion.volume_db = 0
	
func level_transition(on_sound_finished : Callable):
	$MainMusic.volume_db = -80
	$MainAmbient.volume_db = -80
	$MainMusicAddPercussion.volume_db = -80
	$WizzardTeleportSfx.finished.connect(on_sound_finished)
	$WizzardTeleportSfx.play()
	
func win_game(on_sound_finished):
	$MainMusic.volume_db = -80
	$MainAmbient.volume_db = -80
	$MainMusicAddPercussion.volume_db = -80
	if on_sound_finished != null:
		$WinGameMusic.finished.connect(on_sound_finished)
	$WinGameMusic.play()
