extends Node2D

@export var timeBetweenShots = 2
var canShootAgain = true
const bulletPath = preload('res://Weapon--Gun/Bullet.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	$BulletTimer.wait_time = timeBetweenShots
	global_position = get_parent().position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().facingRight:
		$AnimatedSprite2D.flip_h = false
		position.x = 0
		if get_parent().facingUpwards && not get_parent().crouching:
			rotation = 11*PI/6
		else:
			rotation = 0
	else:
		$AnimatedSprite2D.flip_h = true
		position.x = -15
		if get_parent().facingUpwards && not get_parent().crouching:
			rotation = PI/6
		else:
			rotation = 0
	
	if get_parent().crouching:
		position.y = 25
	else:
		position.y = 15

func shoot():
	if canShootAgain:
		var bullet_container = get_tree().current_scene.get_node("Bullets")
		var bullet = bulletPath.instantiate()
		
		bullet.playerName = get_parent().name
		
		# Set position and velocity
		if get_parent().facingRight:
			bullet.rotation = 0
			bullet.velocity = Vector2(400.0, 0.0)
			bullet.global_position.x = global_position.x + 25
			bullet.global_position.y = global_position.y - 3
			if get_parent().facingUpwards && not get_parent().crouching:
				#Process upwards rotation when facing to the right
				bullet.global_rotation = 11*PI/6
				bullet.velocity = bullet.velocity.rotated(11*PI/6)
				bullet.global_position.y = global_position.y - 15
		else:
			bullet.rotation = PI
			bullet.velocity = Vector2(-400.0, 0.0)
			bullet.global_position.x = global_position.x - 25
			bullet.global_position.y = global_position.y - 3
			if get_parent().facingUpwards && not get_parent().crouching:
				#Process upwards rotation when facing to the left
				bullet.global_rotation = 7*PI/6
				bullet.velocity = bullet.velocity.rotated(PI/6)
				bullet.global_position.y = global_position.y - 15
		
		if get_parent().crouching:
				bullet.global_position.y = global_position.y + 20
		
		# Add the bullet to the scene
		bullet_container.add_child(bullet)
		
		# Disable shooting until BulletTimer is done
		canShootAgain = false
		$BulletTimer.start()


# Enable shooting again
func _on_bullet_timer_timeout():
	canShootAgain = true
