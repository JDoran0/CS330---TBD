extends Control

const CURSOR = "res://controller_cursor.tscn"
var startingLineup = []
var cursor_instance = Node2D

var chickArea = false
var meteorArea = false
var gunArea = false
var punchArea = false
var bearArea = false
var lastArea = false
var contArea = false

func _ready() -> void:
	var cursor_scene = load(CURSOR)
	var cursor = cursor_scene.instantiate()
	cursor.player_id = 0
	add_child(cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack0"):
		if chickArea:
			if chickenActive == false and startingLineup.size() >= 4:
				_on_chicken_toggled(false)
			else:
				_on_chicken_toggled(!chickenActive)
		elif meteorArea:
			if meteorsActive == false and startingLineup.size() >= 4:
				_on_meteors_toggled(false)
			else:
				_on_meteors_toggled(!meteorsActive)
		elif gunArea:
			if gunActive == false and startingLineup.size() >= 4:
				_on_gun_toggled(false)
			else:
				_on_gun_toggled(!gunActive)
		elif punchArea:
			if punchActive == false and startingLineup.size() >= 4:
				_on_one_punch_toggled(false)
			else:
				_on_one_punch_toggled(!punchActive)
		elif bearArea:
			if bearActive == false and startingLineup.size() >= 4:
				_on_bear_toggled(false)
			else:
				_on_bear_toggled(!bearActive)
		elif lastArea:
			if lastActive == false and startingLineup.size() >= 4:
				_on_last_toggled(false)
			else:
				_on_last_toggled(!lastActive)
		elif contArea && startingLineup.size() == 4:
			_on_continue_button_pressed()
		else:
			print("Nothing")


# Chicken Set-Up
var chickenActive = false

func _on_chicken_mouse_entered() -> void:
	if not chickenActive:
		$CardButtons/Cards/Chicken.pivot_offset = $CardButtons/Cards/Chicken.size / 2
		$CardButtons/Cards/Chicken.scale *= Vector2(1.1, 1.1)

func _on_chicken_mouse_exited() -> void:
	if not chickenActive:
		$CardButtons/Cards/Chicken.scale = Vector2(1, 1)

func _on_chicken_toggled(Chicken: bool) -> void:
	if Chicken and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Chicken.")
		return
	
	chickenActive = Chicken 
	if Chicken:
		print("Chicken Selected")
		startingLineup.append("Chick")
		$CardButtons/Cards/Chicken.scale = Vector2(1.1, 1.1)  # Keep scaled up when active
	else:
		print("Chicken Not On")
		startingLineup.erase("Chick")
		$CardButtons/Cards/Chicken.scale = Vector2(1, 1)
		
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
		$CardButtons/Cards/Meteors.pivot_offset = $CardButtons/Cards/Meteors.size / 2
		$CardButtons/Cards/Meteors.scale *= Vector2(1.1, 1.1)

func _on_meteors_mouse_exited() -> void:
	if not meteorsActive:
		$CardButtons/Cards/Meteors.scale = Vector2(1, 1)

func _on_meteors_toggled(Meteors: bool) -> void:
	
	if Meteors and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Meteors.")
		return
	
	meteorsActive = Meteors
	if Meteors:
		print("Meteors Selected")
		startingLineup.append("Meteor")
		$CardButtons/Cards/Meteors.scale = Vector2(1.1, 1.1)
	else:
		print("Meteor Not On")
		startingLineup.erase("Meteor")
		$CardButtons/Cards/Meteors.scale = Vector2(1, 1)
		
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
		$CardButtons/Cards/Gun.pivot_offset = $CardButtons/Cards/Gun.size / 2
		$CardButtons/Cards/Gun.scale *= Vector2(1.1, 1.1)

func _on_gun_mouse_exited() -> void:
	if not gunActive:
		$CardButtons/Cards/Gun.scale = Vector2(1, 1)

func _on_gun_toggled(Gun: bool) -> void:
	
	if Gun and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Gun.")
		return
	
	gunActive = Gun
	if Gun:
		print("Gun Selected")
		startingLineup.append("Gun")
		$CardButtons/Cards/Gun.scale = Vector2(1.1, 1.1)
	else:
		print("Gun Not On")
		startingLineup.erase("Gun")
		$CardButtons/Cards/Gun.scale = Vector2(1, 1)
		
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
		$CardButtons/Cards2/OnePunch.pivot_offset = $CardButtons/Cards2/OnePunch.size / 2
		$CardButtons/Cards2/OnePunch.scale *= Vector2(1.1, 1.1)

func _on_one_punch_mouse_exited() -> void:
	if not punchActive:
		$CardButtons/Cards2/OnePunch.scale = Vector2(1, 1)

func _on_one_punch_toggled(Punch: bool) -> void:
	
	if Punch and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Meteors.")
		return
		
	punchActive = Punch
	if Punch:
		print("Punch Selected")
		startingLineup.append("Punch")
		$CardButtons/Cards2/OnePunch.scale = Vector2(1.1, 1.1)
	else:
		print("Punch Not On")
		startingLineup.erase("Punch")
		$CardButtons/Cards2/OnePunch.scale = Vector2(1, 1)
		
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
		$CardButtons/Cards2/Bear.pivot_offset = $CardButtons/Cards2/Bear.size / 2
		$CardButtons/Cards2/Bear.scale *= Vector2(1.1, 1.1)

func _on_bear_mouse_exited() -> void:
	if not bearActive:
		$CardButtons/Cards2/Bear.scale = Vector2(1, 1)

func _on_bear_toggled(Bear: bool) -> void:
	
	if Bear and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Meteors.")
		return
		
	bearActive = Bear
	if Bear:
		print("Bear Selected")
		startingLineup.append("Bear")
		$CardButtons/Cards2/Bear.scale = Vector2(1.1, 1.1)
	else:
		print("Bear Not On")
		startingLineup.erase("Bear")
		$CardButtons/Cards2/Bear.scale = Vector2(1, 1)
		
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
		$CardButtons/Cards2/Last.pivot_offset = $CardButtons/Cards2/Last.size / 2
		$CardButtons/Cards2/Last.scale *= Vector2(1.1, 1.1)

func _on_last_mouse_exited() -> void:
	if not lastActive:
		$CardButtons/Cards2/Last.scale = Vector2(1, 1)

func _on_last_toggled(Last: bool) -> void:
	
	if Last and startingLineup.size() >= 4:
		print("Maximum cards selected. Cannot select Meteors.")
		return
		
	lastActive = Last
	if Last:
		print("Last Selected")
		startingLineup.append("Last")
		$CardButtons/Cards2/Last.scale = Vector2(1.1, 1.1)
	else:
		print("Last Not On")
		startingLineup.erase("Last")
		$CardButtons/Cards2/Last.scale = Vector2(1, 1)
		
	_update_start_button()
	
	for n in startingLineup.size():
		print(startingLineup[n])

func _on_last_2d_area_entered(area: Area2D) -> void:
	lastArea = true
	_on_last_mouse_entered()

func _on_last_2d_area_exited(area: Area2D) -> void:
	lastArea = false
	_on_last_mouse_exited()

# Getting the first card and setting up the rest
func setUp():
	var randomIndex = randi() % startingLineup.size()
	var randomCard = startingLineup[randomIndex]
	
	var restOfCards = startingLineup.duplicate()
	restOfCards.erase(randomCard)
	
	return {"Random Card": randomCard, "Rest of Cards": restOfCards}

# Setting up Continue Button
func _update_start_button():
	var contButton = $ContinueButton
	if startingLineup.size() == 4:
		contButton.disabled = false
	else:
		contButton.disabled = true

func _on_continue_button_pressed() -> void:
	print("Game Started with lineup:", startingLineup)
	get_tree().change_scene_to_file("res://MainGamplayScene.tscn")

func _on_cont_area_area_entered(area: Area2D) -> void:
	contArea = true

func _on_cont_area_area_exited(area: Area2D) -> void:
	contArea = false