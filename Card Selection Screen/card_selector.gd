extends Control

const CURSOR = "res://Card Selection Screen/controller_cursor.tscn"
var startingLineup = []
var cursor_instance = Node2D

#plays when a card is selected
@onready var clickSound = $ClickPop

#plays when too many cards are being selected
@onready var limit = $Notif

@onready var chickenCard = $CardButtons/Cards/Chicken
@onready var meteorCard = $CardButtons/Cards/Meteors
@onready var gunCard = $CardButtons/Cards/Gun
@onready var onePunchCard = $CardButtons/Cards2/OnePunch
@onready var bearCard = $CardButtons/Cards2/Bear
@onready var lastCard = $CardButtons/Cards2/Last

var chickArea = false
var meteorArea = false
var gunArea = false
var punchArea = false
var bearArea = false
var lastArea = false
var contArea = false


func _ready() -> void:
	
	#makes the begin button dim until 4 cards are selected
	$ContinueButton/CardBegin.modulate = Color(1.0, 1.0, 1.0, 0.5)
	chickenCard.modulate = Color(0.5, 0.5, 0.5, 1)
	meteorCard.modulate = Color(0.5, 0.5, 0.5, 1)
	gunCard.modulate = Color(0.5, 0.5, 0.5, 1)
	onePunchCard.modulate = Color(0.5, 0.5, 0.5, 1)
	bearCard.modulate = Color(0.5, 0.5, 0.5, 1)
	lastCard.modulate = Color(0.5, 0.5, 0.5, 1)
	
	
	var cursor_scene = load(CURSOR)
	var cursor = cursor_scene.instantiate()
	cursor.player_id = 0
	add_child(cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#light up the begin button if 4 cards selected
	if startingLineup.size() == 4:
		$ContinueButton/CardBegin.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		$ContinueButton/CardBegin.modulate = Color(1.0, 1.0, 1.0, 0.5)
	
	#Checks if the controller user selected any cards
	if Input.is_action_just_pressed("attack0"):
		if chickArea:
			if chickenActive == false and startingLineup.size() >= 4:
				_on_chicken_toggled(false)
				limit.play()
			else:
				clickSound.play()
				_on_chicken_toggled(!chickenActive)
		elif meteorArea:
			if meteorsActive == false and startingLineup.size() >= 4:
				limit.play()
				_on_meteors_toggled(false)
			else:
				clickSound.play()
				_on_meteors_toggled(!meteorsActive)
		elif gunArea:
			if gunActive == false and startingLineup.size() >= 4:
				limit.play()
				_on_gun_toggled(false)
			else:
				clickSound.play()
				_on_gun_toggled(!gunActive)
		elif punchArea:
			if punchActive == false and startingLineup.size() >= 4:
				limit.play()
				_on_one_punch_toggled(false)
			else:
				clickSound.play()
				_on_one_punch_toggled(!punchActive)
		elif bearArea:
			if bearActive == false and startingLineup.size() >= 4:
				limit.play()
				_on_bear_toggled(false)
			else:
				clickSound.play()
				_on_bear_toggled(!bearActive)
		elif lastArea:
			if lastActive == false and startingLineup.size() >= 4:
				limit.play()
				_on_last_toggled(false)
			else:
				clickSound.play()
				_on_last_toggled(!lastActive)
		elif contArea && startingLineup.size() == 4:
			_on_continue_button_pressed()


# Chicken Set-Up
var chickenActive = false

func _on_chicken_mouse_entered() -> void:
	if !chickenActive:
		chickenCard.pivot_offset = chickenCard.size / 2
		chickenCard.scale *= Vector2(1.1, 1.1)

func _on_chicken_mouse_exited() -> void:
	if !chickenActive:
		chickenCard.scale = Vector2(1, 1)

func _on_chicken_toggled(Chicken: bool) -> void:
	if startingLineup.size() >= 4:
		if Chicken:
			limit.play()
			return
	
	chickenActive = Chicken 
	
	if Chicken:
		clickSound.play()
		chickenCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Chick")
		chickenCard.scale = Vector2(1.1, 1.1)  # Keep scaled up when active
	else:
		clickSound.play()
		chickenCard.modulate = Color(0.5, 0.5, 0.5, 1)
		startingLineup.erase("Chick")
		chickenCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_chick_area_area_entered(area: Area2D) -> void:
	chickArea = true
	_on_chicken_mouse_entered()

func _on_chick_area_area_exited(area: Area2D) -> void:
	chickArea = false
	_on_chicken_mouse_exited()

# Meteors Set-Up
var meteorsActive = false

func _on_meteors_mouse_entered() -> void:
	if not meteorsActive:
		meteorCard.pivot_offset = meteorCard.size / 2
		meteorCard.scale *= Vector2(1.1, 1.1)

func _on_meteors_mouse_exited() -> void:
	if not meteorsActive:
		meteorCard.scale = Vector2(1, 1)

func _on_meteors_toggled(Meteors: bool) -> void:
	if startingLineup.size() >= 4:
		if Meteors:
			limit.play()
			return
	
	meteorsActive = Meteors
	
	if Meteors:
		clickSound.play()
		meteorCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Meteor")
		meteorCard.scale = Vector2(1.1, 1.1)
	else:
		clickSound.play()
		meteorCard.modulate = Color(0.5, 0.5, 0.5, 1)
		startingLineup.erase("Meteor")
		meteorCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_meteor_area_area_entered(area: Area2D) -> void:
	meteorArea = true
	_on_meteors_mouse_entered()

func _on_meteor_area_area_exited(area: Area2D) -> void:
	meteorArea = false
	_on_meteors_mouse_exited()

# Gun Card Set Up
var gunActive = false

func _on_gun_mouse_entered() -> void:
	if not gunActive:
		gunCard.pivot_offset = gunCard.size / 2
		gunCard.scale *= Vector2(1.1, 1.1)

func _on_gun_mouse_exited() -> void:
	if not gunActive:
		gunCard.scale = Vector2(1, 1)

func _on_gun_toggled(Gun: bool) -> void:
	if startingLineup.size() >= 4:
		if Gun:
			limit.play()
			return
	
	gunActive = Gun
	
	if Gun:
		clickSound.play()
		gunCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Gun")
		gunCard.scale = Vector2(1.1, 1.1)
	else:
		clickSound.play()
		gunCard.modulate = Color(0.5, 0.5, 0.5, 1)
		print("Gun Not On")
		startingLineup.erase("Gun")
		gunCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])
		
func _on_gun_area_area_entered(area: Area2D) -> void:
	gunArea = true
	_on_gun_mouse_entered()

func _on_gun_area_area_exited(area: Area2D) -> void:
	gunArea = false
	_on_gun_mouse_exited()

# One Punch Set Up
var punchActive = false

func _on_one_punch_mouse_entered() -> void:
	if not punchActive:
		onePunchCard.pivot_offset = onePunchCard.size / 2
		onePunchCard.scale *= Vector2(1.1, 1.1)

func _on_one_punch_mouse_exited() -> void:
	if not punchActive:
		onePunchCard.scale = Vector2(1, 1)

func _on_one_punch_toggled(Punch: bool) -> void:
	if startingLineup.size() >= 4:
		if Punch:
			limit.play()
			return
		
	punchActive = Punch
	
	if Punch:
		clickSound.play()
		onePunchCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Punch")
		onePunchCard.scale = Vector2(1.1, 1.1)
	else:
		clickSound.play()
		onePunchCard.modulate = Color(0.5, 0.5, 0.5, 1)
		startingLineup.erase("Punch")
		onePunchCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_one_area_area_entered(area: Area2D) -> void:
	punchArea = true
	_on_one_punch_mouse_entered()

func _on_one_area_area_exited(area: Area2D) -> void:
	punchArea = false
	_on_one_punch_mouse_exited()

# Bear Set Up
var bearActive = false

func _on_bear_mouse_entered() -> void:
	if not bearActive:
		bearCard.pivot_offset = bearCard.size / 2
		bearCard.scale *= Vector2(1.1, 1.1)

func _on_bear_mouse_exited() -> void:
	if not bearActive:
		bearCard.scale = Vector2(1, 1)

func _on_bear_toggled(Bear: bool) -> void:
	if startingLineup.size() >= 4:
		if Bear:
			limit.play()
			return
		
	bearActive = Bear
	
	if Bear:
		clickSound.play()
		bearCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Bear")
		bearCard.scale = Vector2(1.1, 1.1)
	else:
		clickSound.play()
		bearCard.modulate = Color(0.5, 0.5, 0.5, 1)
		startingLineup.erase("Bear")
		bearCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_bear_area_area_entered(area: Area2D) -> void:
	bearArea = true
	_on_bear_mouse_entered()

func _on_bear_area_area_exited(area: Area2D) -> void:
	bearArea = false
	_on_bear_mouse_exited()
	
# Last
var lastActive = false

func _on_last_mouse_entered() -> void:
	if not lastActive:
		lastCard.pivot_offset = lastCard.size / 2
		lastCard.scale *= Vector2(1.1, 1.1)

func _on_last_mouse_exited() -> void:
	if not lastActive:
		lastCard.scale = Vector2(1, 1)

func _on_last_toggled(Last: bool) -> void:
	if startingLineup.size() >= 4:
		if Last:
			limit.play()
			return
		
	lastActive = Last
	
	if Last:
		clickSound.play()
		lastCard.modulate = Color(1, 1, 1, 1)
		startingLineup.append("Last")
		lastCard.scale = Vector2(1.1, 1.1)
	else:
		clickSound.play()
		lastCard.modulate = Color(0.5, 0.5, 0.5, 1)
		startingLineup.erase("Last")
		lastCard.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_last_2d_area_entered(area: Area2D) -> void:
	lastArea = true
	_on_last_mouse_entered()

func _on_last_2d_area_exited(area: Area2D) -> void:
	lastArea = false
	_on_last_mouse_exited()

# Setting up Continue Button
func _update_start_button():
	var contButton = $ContinueButton
	if startingLineup.size() == 4:
		contButton.disabled = false
	else:
		contButton.disabled = true

func _on_continue_button_pressed() -> void:
	print("Game Started with lineup:", startingLineup)
	var randomIndex = randi() % startingLineup.size()
	Global.randomCard = startingLineup[randomIndex]
	
	Global.restOfCards = startingLineup.duplicate()
	Global.restOfCards.erase(Global.randomCard)
	
	print("Random Card:", Global.randomCard)
	print("Rest of Cards:", Global.restOfCards)
	get_tree().change_scene_to_file("res://GamePlay--MainGamePlayFolder/MainGamplayScene.tscn")

func _on_cont_area_area_entered(area: Area2D) -> void:
	contArea = true

func _on_cont_area_area_exited(area: Area2D) -> void:
	contArea = false

func _on_back_button_pressed() -> void:
	MenuBack.play()
	get_tree().change_scene_to_file("res://GamePlay--menus/menu.tscn")
