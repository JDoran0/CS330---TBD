extends CanvasLayer


@onready var animation = $AnimationPlayer
@onready var Chick1 = $Sprite2D
@onready var Chick2 = $Sprite2D2


func _ready() -> void:
	Chick1.visible = false
	Chick2.visible = false
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(_AnimPlayed):
	Chick1.visible = false
	Chick2.visible = false

func playConcussedEffect():
	Chick1.visible = true
	Chick2.visible = true
	animation.play("Flash")
