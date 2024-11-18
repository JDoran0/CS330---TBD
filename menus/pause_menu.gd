extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEscape()
	pass

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

func testEscape():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		unPause()

func _on_resume_pressed() -> void:
	#TODO: add game unpause here, also make sure you can unpause using esc again.
	MenuClick.play()
	unPause()
	pass # Replace with function body.
	

func _on_restart_pressed() -> void:
	unPause()
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	MenuClick.play()
	unPause()
	get_tree().change_scene_to_file("res://menus/settings_menu.tscn")
	pass # Replace with function body.


func _on_controls_pressed() -> void:
	MenuClick.play()
	unPause()
	get_tree().change_scene_to_file("res://menus/controls_menu.tscn")
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	MenuBack.play()
	unPause()
	get_tree().change_scene_to_file("res://menus/menu.tscn")
	pass # Replace with function body.
