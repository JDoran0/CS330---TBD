extends Node2D

#@export var bullet_scene: PackedScene
const bulletPath = preload('res://Weapon--Gun/Bullet.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	var bullet_container = get_tree().current_scene.get_node("Bullets")
	var bullet = bulletPath.instantiate()
	
	# Set position and velocity
	if get_parent().facingRight:
		bullet.rotation = 0
		bullet.velocity = Vector2(400.0, 0.0)
		bullet.global_position.y = global_position.y
		bullet.global_position.x = global_position.x + 40
	else:
		bullet.rotation = PI
		bullet.velocity = Vector2(-400.0, 0.0)
		bullet.global_position.y = global_position.y
		bullet.global_position.x = global_position.x - 40
	
	# Add the bullet to the scene
	bullet_container.add_child(bullet)
