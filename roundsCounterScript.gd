extends Control

@onready var LeftCounter = 0
@onready var RightCounter = 0
@onready var canvas = $"CanvasLayer"

signal finishedAnimation

func _ready() -> void:
	canvas.visible = false
	$CanvasLayer/Fade.animation_finished.connect(onAnimationFinished)


func onAnimationFinished(_animationPlayed):
	get_tree().paused = false
	canvas.visible = false
	finishedAnimation.emit()

func IncreaseLeft():
	get_tree().paused = true
	canvas.visible = true
	LeftCounter += 1
	$CanvasLayer/RoundsCounterText.text = str(LeftCounter, " - ", RightCounter)
	$CanvasLayer/Fade.play("FadeNextRound")


func IncreaseRight():
	get_tree().paused = true
	canvas.visible = true
	RightCounter += 1
	$CanvasLayer/RoundsCounterText.text = str(LeftCounter, " - ", RightCounter)
	$CanvasLayer/Fade.play("FadeNextRound")
