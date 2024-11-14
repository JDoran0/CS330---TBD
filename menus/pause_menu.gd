extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	#TODO: add game unpause here, also make sure you can unpause using esc again.
	MenuClick.play()
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://menus/settings_menu.tscn")
	pass # Replace with function body.


func _on_controls_pressed() -> void:
	MenuClick.play()
	#TODO: Add controls scene
	#get_tree().change_scene_to_file("res://menus/settings_menu.tscn")
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	MenuBack.play()
	get_tree().change_scene_to_file("res://menus/menu.tscn")
	pass # Replace with function body.
