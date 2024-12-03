extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation = $AnimationPlayer


func _ready() -> void:
	color_rect.visible = false
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(AnimPlayed):
	color_rect.visible = false 

func playConcussedEffect():
	color_rect.visible = true
	animation.play("Flash")
