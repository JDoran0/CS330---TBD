extends Node
@export var mob_scene: PackedScene

func _ready():
	for n in range(40):
		spawnPlush()
		
func spawnPlush():
	var plush = mob_scene.instantiate()
	plush.add_to_group("Plushie")
	var plushSpawnLocation = $PlushiePath/PlushieSpawnLocation
	plushSpawnLocation.progress_ratio = randf()
	var direction = plushSpawnLocation.rotation + PI / 2
	plush.position = plushSpawnLocation.position
	direction -= randf_range(0, PI / 8)
	plush.rotation = direction
	var velocity = Vector2(randf_range(450.0, 550.0), 0.0)
	plush.linear_velocity = velocity.rotated(direction)
	
	add_child(plush)
