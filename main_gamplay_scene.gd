extends Node2D

const MAIN_MENU_SCENE = "res://menu.tscn"
const GAMEPLAY_SCENE = "res://MainGameplayScene.tscn"

static var controllerCount = 0
var ControllerNegativeDeadzone = -0.09
var ControllerPositiveDeadzone = 0.09

var playedOnce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	controllerCount = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().current_scene != preload(MAIN_MENU_SCENE):
		playedOnce = true
	if get_tree().current_scene == preload(MAIN_MENU_SCENE):
		controllerCount = 0

##Assigns a controller to the player who calls this
	#Assigns -1 to player 1 if they are a keyboard player (only 1 controller connected)
func ClaimController(player) -> int:
	print_debug("Controller count: ", Input.get_connected_joypads().size())
	if Input.get_connected_joypads().size() == 1 && player.name == "Player1":
		return -1
	else:
		var retValue = controllerCount
		controllerCount += 1
		return retValue

##Deadzone to ensure the joysticks dont cause the player to drift when idle
func GetControllerPositiveDeadzone():
	return ControllerPositiveDeadzone

##Deadzone to ensure the joysticks dont cause the player to drift when idle
func GetControllerNegativeDeadzone():
	return ControllerNegativeDeadzone
