extends RigidBody2D

@export var bounce = 150

func _ready():
	pass
	
func _process(delta: float):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var bounce_direction = (global_position - body.global_position).normalized()
		var velocity = bounce_direction * bounce
		body.velocity = velocity * -1
		body.getStunned()
		body.move_and_slide()
		body.dealDamage(5)
	gravity_scale = 0
	
