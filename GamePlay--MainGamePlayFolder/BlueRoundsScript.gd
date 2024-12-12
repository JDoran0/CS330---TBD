extends Control

@onready var RoundsWon = 0


var blueWon = false

func _ready() -> void:
	$Empty.visible = true
	$Half.visible = false
	$Full.visible = false

#update the score tracker
func IncreaseRoundsWonBlue():
	RoundsWon += 1
	if RoundsWon == 1:
		$Empty.visible = false
		$Half.visible = true
	if RoundsWon == 2:
		$Half.visible = false
		$Full.visible = true
	if RoundsWon == 3:
		blueWon = true

func CheckWin():
	return blueWon
