extends Node2D

var speed: float = 1000.0  
var player_id: int = 0    

func _process(delta: float) -> void:
	var x_axis = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)
	var y_axis = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	var movement = Vector2(x_axis, y_axis) * speed * delta

	position += movement

	var screen_size = get_viewport().get_visible_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
