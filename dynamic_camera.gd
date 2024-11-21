extends Camera2D

@export var player1: NodePath
@export var player2: NodePath

@export var min_zoom: Vector2 = Vector2(1, 1)
@export var max_zoom: Vector2 = Vector2(3, 3)

@export var min_distance: float = 100.0
@export var max_distance: float = 500.0

func _process(delta):
	player1 = "../Player1"
	player2 = "../Player2"
	
	if not player1 or not player2:
		return

	var pos1 = get_node(player1).global_position
	var pos2 = get_node(player2).global_position

	# Calculate the midpoint
	var midpoint = (pos1 + pos2) / 2.0

	# Calculate the distance between the players
	var distance = pos1.distance_to(pos2)

	# Adjust camera position
	global_position = midpoint

	# Adjust zoom based on distance
	var t = clamp((distance - min_distance) / (max_distance - min_distance), 0, 1)
	zoom = lerp(max_zoom, min_zoom, t)
