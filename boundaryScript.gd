extends Area2D



#if overlapping with the player deal damage
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"../Player1".health -= 100
		$"../Player2".health -= 100
