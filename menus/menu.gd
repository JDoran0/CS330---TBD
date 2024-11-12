extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Button handles starting the game, currently takes us to the actual game scene for now
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainGamplayScene.tscn")
	#TODO: play a sound here
	pass # Replace with function body.

# Button handles taking the player to a settings menu, takes them to settings scene
func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/settings_menu.tscn")
	#TODO: play a sound here
	pass # Replace with function body.

# Button handles showing the player the controls, takes them to a scene showing controls
func _on_controls_button_pressed() -> void:
	#get_tree().change_scene_to_file() #<- drag the scene for the 
	#TODO: play a sound here
	get_tree().change_scene_to_file("res://menus/Controls.tscn")

# Button handles quitting out of the game
func _on_exit_game_button_pressed() -> void:
	#TODO: play a sound here
	get_tree().quit()