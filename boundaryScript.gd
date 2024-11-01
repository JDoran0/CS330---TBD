extends Area2D



#if overlapping with the player deal damage
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"../CharacterBody2D".health -= 100
