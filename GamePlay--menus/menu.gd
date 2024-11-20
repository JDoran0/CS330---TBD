extends Control

# Button handles starting the game, currently takes us to the actual game scene for now
func _on_start_button_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://GamePlay--MainGamePlayFolder/MainGamplayScene.tscn")

# Button handles taking the player to a settings menu, takes them to settings scene
func _on_settings_button_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://GamePlay--menus/settings_menu.tscn")

# Button handles showing the player the controls, takes them to a scene showing controls
func _on_controls_button_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://GamePlay--menus/controls_menu.tscn") #<- drag the scene for the 

# Button handles quitting out of the game
func _on_exit_game_button_pressed() -> void:
	MenuBack.play()
	get_tree().quit()
