extends RigidBody2D

func _ready():
	pass
	
func _process(delta: float):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()