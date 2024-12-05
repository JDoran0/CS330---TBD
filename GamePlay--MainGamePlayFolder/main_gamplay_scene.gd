extends Node2D

const MAIN_MENU_SCENE = "res://GamePlay--menus/menu.tscn"
const GAMEPLAY_SCENE = "res://GamePlay--menus/MainGameplayScene.tscn"
const PLUSHIE_SPAWNER_SCENE = "res://MapMod--Bear/plushie_spawner.tscn"
const METEOR_SPAWNER_SCENE = "res://MapMod--Meteors/Meteor_spawner.tscn"

@onready var player1 = $Player1
@onready var player2 = $Player2
var winsP1 = 0
var winsP2 = 0

static var controllerCount = 0
var ControllerNegativeDeadzone = -0.09
var ControllerPositiveDeadzone = 0.09
var P2spawn = Vector2(799, 447)
var P1spawn = Vector2(256, 456)

var playedOnce = false

@onready var card_icon = $"CanvasLayer/CardSlot/CardIcon"

# Called when the node enters the scene tree for the first time.
func _ready():
	MatchStartTimer()
	$GameTimer.start()
	controllerCount = 0
	Global.DAMAGE_PER_HIT = 10
	Global.weaponType = null
	print("Damage:", Global.DAMAGE_PER_HIT)
	$CardTimer.wait_time = randi_range(5, 10)
	print("Timer set for:", $CardTimer.wait_time, "seconds")
	$CardTimer.start()
	
	$CanvasLayer/MatchStartText.visible = false
	
	var card_texture = preload("res://Card Selection Screen/Card Textures/None.png")
	update_card_slot(card_texture)

func _process(_delta):
	if get_tree().current_scene != preload(MAIN_MENU_SCENE):
		playedOnce = true
	if get_tree().current_scene == preload(MAIN_MENU_SCENE):
		controllerCount = 0
		
	$CanvasLayer/MatchStartText.text = str(round($MatchStartTimer.time_left))
	
	$CanvasLayer/GameTimerVisual.text = str(round($GameTimer.time_left))
	
	if winsP1  >= 3 or winsP2 >= 3:
		get_tree().change_scene_to_file("res://GamePlay--menus/game_over.tscn")
		
	checkPlayerHealth()

func checkPlayerHealth():
	if $GameTimer.time_left == 0:
		if player1.health > player2.health:
			winsP1 += 1
			MatchStartTimer()
			$GameTimer.start()
			$CanvasLayer/NumRoundWonBlue.IncreaseRoundsWonBlue()
			ResetCharacters()
			
		elif player2.health > player1.health:
			winsP2 += 1
			MatchStartTimer()
			$GameTimer.start()
			$CanvasLayer/NumRoundWonRed.IncreaseRoundsWonRed()
			ResetCharacters()
			
		else:
			winsP2 += 1
			winsP1 += 1
			MatchStartTimer()
			$GameTimer.start()
			$CanvasLayer/NumRoundWonRed.IncreaseRoundsWonRed()
			$CanvasLayer/NumRoundWonBlue.IncreaseRoundsWonBlue()
			ResetCharacters()
			
	if player1.health <= 0:
			winsP2 += 1
			MatchStartTimer()
			$GameTimer.start()
			$CanvasLayer/NumRoundWonRed.IncreaseRoundsWonRed()
			ResetCharacters()
			
	if player2.health <= 0:
		winsP1 += 1
		MatchStartTimer()
		$GameTimer.start()
		$CanvasLayer/NumRoundWonBlue.IncreaseRoundsWonBlue()
		ResetCharacters()

func MatchStartTimer():
	$CanvasLayer/MatchStartText.visible = true
	get_tree().paused = true
	$MatchStartTimer.start()
	

func ResetCharacters():
		player2.health = 100
		player1.health = 100
		player2.position = P2spawn
		player1.position = P1spawn
		player1.velocity = Vector2(0, 0)
		player2.velocity = Vector2(0, 0)

func _on_game_timer_timeout() -> void:
	$GameTimer.stop()
	checkPlayerHealth()

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
	
	var card_texture: Texture = null
	
	if(Global.randomCard == "Chick"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - Rubber Chicken.png")
		Chicken();
	elif(Global.randomCard == "Bear"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - Bear Card.png")
		theBear();
	elif(Global.randomCard == "Punch"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - The Punch.png")
		onePunch()
	elif(Global.randomCard == "Meteor"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - Meteor Card.png")
		Meteors()
	elif(Global.randomCard == "Gun"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - Gun Card.png")
		theGun()
	elif(Global.randomCard == "Last"):
		card_texture = preload("res://Card Selection Screen/Card Textures/Tarot - Ice.png")
		last()
	
	update_card_slot(card_texture)
	
	var randomIndex = randi() % Global.restOfCards.size()
	Global.prevCard = Global.randomCard
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
		
func update_card_slot(card_texture: Texture):
	card_icon.texture = card_texture


func _on_match_start_timer_timeout() -> void:
	$CanvasLayer/MatchStartText.visible = false
	$MatchStartTimer.stop()
	get_tree().paused = false
	
