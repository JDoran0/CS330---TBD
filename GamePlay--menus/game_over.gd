extends Control

#NOTE: May need to add a way to save the previous match's properties 
# and then transfer it over to here.

# Start same game
func _on_re_match_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://GamePlay--MainGamplayScene.tscn")

# Start new game
func _on_new_match_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://GamePlay--MainGamplayScene.tscn")

# menu Button
func _on_return_to_menu_pressed() -> void:
	MenuBack.play()
	get_tree().change_scene_to_file("res://GamePlay--menus/menu.tscn")
