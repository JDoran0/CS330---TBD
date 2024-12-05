extends Control

@onready var RoundsWon = 0

func _ready() -> void:
	$Empty.visible = true

func IncreaseRoundsWonBlue():
	RoundsWon += 1
	if RoundsWon == 1:
		$Empty.visible = false
		$Half.visible = true
	if RoundsWon == 2:
		$Half.visible = false
		$Full.visible = true
	if RoundsWon >= 3:
		emit_signal("BlueWon")
