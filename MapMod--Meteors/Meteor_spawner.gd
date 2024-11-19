extends Node
@export var mob_scene: PackedScene
@export var timeBetweenMeteors = .125

# Start between meteors
func _ready():
	$MeteorTimer.wait_time = timeBetweenMeteors
	$MeteorTimer.start()

# Spawn instances of meteors
func _on_meteor_timer_timeout() -> void:
	var meteor = mob_scene.instantiate()
	var meteorSpawnLocation = $MeteorPath/MeteorSpawnLoc
	meteorSpawnLocation.progress_ratio = randf()
	var direction = meteorSpawnLocation.rotation + PI / 4
	meteor.position = meteorSpawnLocation.position
	direction -= randf_range(0, PI / 8)
	meteor.rotation = direction
	var velocity = Vector2(randf_range(1000.0, 1000.0), 0.0)
	meteor.linear_velocity = velocity.rotated(direction)
	add_child(meteor)
