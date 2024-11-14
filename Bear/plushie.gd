extends RigidBody2D

func _ready():
	pass

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Hit by ", body.name)
		var bounce_direction = (global_position - body.global_position).normalized()
		var velocity = bounce_direction * 500
		body.velocity = velocity * -1
		body.getStunned()
		body.move_and_slide()
