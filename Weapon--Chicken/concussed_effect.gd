extends CanvasLayer

@onready var Chicken1 = $Sprite2D
@onready var Chicken2 = $Sprite2D2
@onready var animation = $AnimationPlayer


func _ready() -> void:
	Chicken1.visible = false
	Chicken2.visible = false
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(AnimPlayed):
	Chicken1.visible = false
	Chicken2.visible = false

func playConcussedEffect():
	Chicken1.visible = true
	Chicken2.visible = true
	animation.play("Flash")
