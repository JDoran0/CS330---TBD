extends Node
@export var mob_scene: PackedScene

@export var numberOfBears = 40

#create 40 bears
func _ready():
	for n in range(numberOfBears):
		spawnPlush()

#create instance of bear
func spawnPlush():
	var plush = mob_scene.instantiate()
	plush.add_to_group("Plushie")
	var viewport_size = get_viewport().get_visible_rect().size
	var center = viewport_size / 2
	var spawn_side = randi() % 4
	var spawn_position = Vector2()
	if spawn_side == 0:
		spawn_position.x = 0
		spawn_position.y = randf_range(0, viewport_size.y)
	elif spawn_side == 1:
		spawn_position.x = viewport_size.x
		spawn_position.y = randf_range(0, viewport_size.y)
	elif spawn_side == 2:
		spawn_position.x = randf_range(0, viewport_size.x)
		spawn_position.y = 0
	elif spawn_side == 3:
		spawn_position.x = randf_range(0, viewport_size.x)
		spawn_position.y = viewport_size.y
	plush.position = spawn_position
	var direction = (center - spawn_position).normalized()
	plush.linear_velocity = direction * randf_range(450.0, 550.0)

	add_child(plush)
