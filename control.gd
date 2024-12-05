extends Control

@onready var RoundsWon = 0

var BlueWon = false

func _ready() -> void:
	$Empty.visible = true
	$Half.visible = false
	$Full.visible = false

func IncreaseRoundsWonBlue():
	RoundsWon += 1
	if RoundsWon == 1:
		$Empty.visible = false
		$Half.visible = true
	if RoundsWon == 2:
		$Half.visible = false
		$Full.visible = true
	if RoundsWon == 3:
		#get_tree().change_scene_to_file("res://GamePlay--menus/game_over.tscn")
		BlueWon = true

func CheckWin():
	return BlueWon
