extends Node2D

const MAIN_MENU_SCENE = "res://menus/menu.tscn"
const GAMEPLAY_SCENE = "res://menus/MainGameplayScene.tscn"
const PLUSHIE_SPAWNER_SCENE = "res://Bear/plushie_spawner.tscn"

static var controllerCount = 0
var ControllerNegativeDeadzone = -0.09
var ControllerPositiveDeadzone = 0.09

var playedOnce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	controllerCount = 0
	
	if true:
		theBear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().current_scene != preload(MAIN_MENU_SCENE):
		playedOnce = true
	if get_tree().current_scene == preload(MAIN_MENU_SCENE):
		controllerCount = 0

##Assigns a controller to the player who calls this
	#Assigns -1 to player 1 if they are a keyboard player (only 1 controller connected)
func ClaimController(player) -> int:
	print_debug("Controller count: ", Input.get_connected_joypads().size())
	if Input.get_connected_joypads().size() == 0 && player.name == "Player1":
		return -1
	elif Input.get_connected_joypads().size() == 1 && player.name == "Player1":
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

func theBear():
	var plushie_spawner_scene = load(PLUSHIE_SPAWNER_SCENE)
	var plushie_spawner_instance = plushie_spawner_scene.instantiate()
	add_child(plushie_spawner_instance)
