extends Control

# Back button
func _on_back_button_pressed() -> void:
	MenuBack.play()
	get_tree().change_scene_to_file("res://GamePlay--menus/menu.tscn")
