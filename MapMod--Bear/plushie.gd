extends RigidBody2D

@export var bounce = 500

# create interaction between bear and player
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var bounce_direction = (global_position - body.global_position).normalized()
		var velocity = bounce_direction * bounce
		body.velocity = velocity * -1
		body.getStunned()
		body.move_and_slide()
