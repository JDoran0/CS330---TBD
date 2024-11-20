extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")

# Check if escape button is pressed
func _process(delta: float) -> void:
	testEscape()

# Functions for handeling the pausing of the game.
func unPause():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()

# pause feature
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()

#pause game with escape
func testEscape():
	#need to connect pause button to controller
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		unPause()

# resume game
func _on_resume_pressed() -> void:
	MenuClick.play()
	unPause()

# restart game
func _on_restart_pressed() -> void:
	MenuClick.play()
	unPause()
	get_tree().reload_current_scene()

# Send self to main menu
func _on_main_menu_pressed() -> void:
	MenuBack.play()
	unPause()
	get_tree().change_scene_to_file("res://GamePlay--menus/menu.tscn")
