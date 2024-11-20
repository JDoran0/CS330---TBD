extends Area2D

 #if overlapping with the player kill the player
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.dealDamage(100)
