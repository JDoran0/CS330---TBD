extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#NOTE: May need to add a way to save the previous match's properties 
# and then transfer it over to here.
func _on_re_match_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://MainGamplayScene.tscn")
	pass # Replace with function body.


func _on_new_match_pressed() -> void:
	MenuClick.play()
	get_tree().change_scene_to_file("res://MainGamplayScene.tscn")
	pass # Replace with function body.


func _on_return_to_menu_pressed() -> void:
	MenuBack.play()
	get_tree().change_scene_to_file("res://menus/menu.tscn")
	pass # Replace with function body.
