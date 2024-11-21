extends Area2D

const KNOCKBACK_MODIFIER = 75.0

# Initialize velocity property
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the bullet based on delta time
	global_position += velocity * delta


# Delete bullets that have left the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node):
	print_debug("COLLISION!")
	if body.is_in_group("Player"):
		var knockback_direction = (global_position - body.global_position).normalized()
		var velocity = knockback_direction * KNOCKBACK_MODIFIER
		body.velocity = velocity * -1
		body.getStunned()
		body.move_and_slide()
		body.dealDamage(34)
		queue_free()
