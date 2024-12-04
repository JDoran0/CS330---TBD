extends Node2D

const MAIN_MENU_SCENE = "res://GamePlay--menus/menu.tscn"
const GAMEPLAY_SCENE = "res://GamePlay--menus/MainGameplayScene.tscn"
const PLUSHIE_SPAWNER_SCENE = "res://MapMod--Bear/plushie_spawner.tscn"
const METEOR_SPAWNER_SCENE = "res://MapMod--Meteors/Meteor_spawner.tscn"

static var controllerCount = 0
var ControllerNegativeDeadzone = -0.09
var ControllerPositiveDeadzone = 0.09

var playedOnce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	controllerCount = 0
	Global.DAMAGE_PER_HIT = 10
	Global.weaponType = null
	print("Damage:", Global.DAMAGE_PER_HIT)
	$CardTimer.wait_time = randi_range(5, 10)
	print("Timer set for:", $CardTimer.wait_time, "seconds")
	$CardTimer.start()

func _process(_delta):
	if get_tree().current_scene != preload(MAIN_MENU_SCENE):
		playedOnce = true
	if get_tree().current_scene == preload(MAIN_MENU_SCENE):
		controllerCount = 0

#Assigns a controller to the player who calls this
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

#Deadzone to ensure the joysticks dont cause the player to drift when idle
func GetControllerPositiveDeadzone():
	return ControllerPositiveDeadzone
func GetControllerNegativeDeadzone():
	return ControllerNegativeDeadzone

func Chicken():
	print("Running Chicken")
	Global.weaponType = "Chicken"
	
# Spawn Meteors
var meteor_spawner_instance = null

func Meteors():
	print("Running Meteors")
	var spawner_scene = load(METEOR_SPAWNER_SCENE)
	meteor_spawner_instance = spawner_scene.instantiate()
	add_child(meteor_spawner_instance)

# Spawn Bears
func theBear():
	print("Running Bear")
	var plushie_spawner_scene = load(PLUSHIE_SPAWNER_SCENE)
	var plushie_spawner_instance = plushie_spawner_scene.instantiate()
	add_child(plushie_spawner_instance)
	
func theGun():
	print("Running Gun")
	Global.weaponType = "Gun"

func onePunch():
	print("Running One Punch")
	Global.weaponType = "OnePunch"

func last():
	print("Running the Last")

func _on_card_timer_timeout():
	
	_cleanup_plushies()
	stop_meteor_timer()
	Global.weaponType = null
	Global.DAMAGE_PER_HIT = 10
	
	$CardTimer.wait_time = randi_range(5, 10)
	print("Timer set for: ", $CardTimer.wait_time, "seconds")
	
	print(Global.randomCard)
	print(Global.restOfCards)
	
	if(Global.randomCard == "Chick"):
		Chicken();
	elif(Global.randomCard == "Bear"):
		theBear();
	elif(Global.randomCard == "Punch"):
		onePunch()
	elif(Global.randomCard == "Meteor"):
		Meteors()
	elif(Global.randomCard == "Gun"):
		theGun()
	elif(Global.randomCard == "Last"):
		last()
	
	var randomIndex = randi() % Global.restOfCards.size()
	Global.restOfCards.append(Global.randomCard)
	Global.randomCard = Global.restOfCards[randomIndex]
	Global.restOfCards.erase(Global.randomCard)
	
func _cleanup_plushies():
	var plushies = get_tree().get_nodes_in_group("Plushie")
	for plush in plushies:
		if plush != null:
			plush.queue_free()
	print("All plushies removed.")

func stop_meteor_timer():
	if meteor_spawner_instance and meteor_spawner_instance.has_node("MeteorTimer"):
		meteor_spawner_instance.get_node("MeteorTimer").stop()
		meteor_spawner_instance.queue_free()
		meteor_spawner_instance = null
		print("Meteor timer stopped and spawner removed.")
	else:
		print("No meteor spawner instance or timer not found.")
