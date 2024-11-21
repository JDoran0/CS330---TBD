extends Node2D

@export var timeBetweenShots = 2
var canShootAgain = true
const bulletPath = preload('res://Weapon--Gun/Bullet.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	$BulletTimer.wait_time = timeBetweenShots


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	if canShootAgain:
		var bullet_container = get_tree().current_scene.get_node("Bullets")
		var bullet = bulletPath.instantiate()
		
		# Set position and velocity
		if get_parent().facingRight:
			bullet.rotation = 0
			bullet.velocity = Vector2(400.0, 0.0)
			bullet.global_position.x = global_position.x + 40
			if get_parent().crouching:
				bullet.global_position.y = global_position.y + 20
			else:
				bullet.global_position.y = global_position.y
		else:
			bullet.rotation = PI
			bullet.velocity = Vector2(-400.0, 0.0)
			bullet.global_position.x = global_position.x - 40
			if get_parent().crouching: 
				bullet.global_position.y = global_position.y + 20
			else:
				bullet.global_position.y = global_position.y
			
		
		# Add the bullet to the scene
		bullet_container.add_child(bullet)
		
		# Disable shooting until BulletTimer is done
		canShootAgain = false
		$BulletTimer.start()


# Enable shooting again
func _on_bullet_timer_timeout():
	canShootAgain = true
