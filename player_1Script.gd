extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Select the device to connect to
@export var playerIndex = 0

@export var facingRight = true

@onready var standing_collision = $standing
@onready var crouching_collision = $crouching

@onready var characterStanding = $"Character(standing)"
@onready var characterCrouching = $"Character(crouching)"
@onready var playerHealthBar = $"../Player1HB"

var health = 100
var stunned = false
var crouching = false


#for debugging, can be removed later
var prevHealth = health

var controllerNumber

func _physics_process(delta: float) -> void:
	
	playAnimation()
	
	#quit game with esc button
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	#if necessary show the health of the player only when updated
	if health != prevHealth:
		print("player health 1:", health)
		prevHealth = health
		playerHealthBar.value = health
		
	#for debug purposes will be changed later, when you jump off the platform the game will close
	if health <= 0:
		get_tree().change_scene_to_file("res://menus/menu.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# check if stunned and if assgined a controller
	if !stunned && controllerNumber != -1:
		processControllerInput(delta)
	
	#check if stunned and if assigned a keyboard
	if !stunned && controllerNumber == -1:
		processKeyboardInput(delta)
	
	#Determine which way the player is facing
	processDirection()
	
	move_and_slide()


func processControllerInput(delta: float) -> void:
	# Ground the character faster. (controller)
	if not is_on_floor() and Input.is_action_just_pressed("down" + str(controllerNumber)):
		velocity += (get_gravity() * delta) * 25
		
	# Handle ducking (controller)
	if Input.is_action_pressed("down" + str(controllerNumber)) and is_on_floor():
		crouching = true
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		crouching = false
		standing_collision.disabled = false
		crouching_collision.disabled = true
	
	# Handle jump. (controller)
	if Input.is_action_just_pressed("jump" + str(controllerNumber)) and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		
	# moving left and right for player1 (controller)
	var controllerDeadzonePos = get_parent().GetControllerPositiveDeadzone()
	var controllerDeadzoneNeg = get_parent().GetControllerNegativeDeadzone()
	var directionDPad := Input.get_axis("left" + str(controllerNumber), "right" + str(controllerNumber))
	var directionStick := Input.get_joy_axis(controllerNumber, JOY_AXIS_LEFT_X)
	if directionDPad < controllerDeadzoneNeg || directionStick < controllerDeadzoneNeg: 
		var direction = min(directionStick, directionDPad)
		velocity.x = direction * SPEED
		
	elif directionDPad > controllerDeadzonePos || directionStick > controllerDeadzonePos:
		var direction = max(directionStick, directionDPad)
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	# Check for punch input (controller)
	if Input.is_action_just_pressed("attack" + str(controllerNumber)):
		processAttackDirection()
		$Fists.attack()



func processKeyboardInput(delta: float) -> void: 
	# faster falling (keyboard)
	if not is_on_floor() and Input.is_action_just_pressed("kbDown"):
		velocity += (get_gravity() * delta) * 25
	
	# Handle ducking (keyboard)
	if Input.is_action_pressed( "kbDown") and is_on_floor():
		crouching = true
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		crouching = false
		standing_collision.disabled = false
		crouching_collision.disabled = true
	
	#handle jumping (keyboard)
	if Input.is_action_just_pressed("kbJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Left and right (keyboard)
	var keyboardDirections := Input.get_axis("kbLeft", "kbRight")
	if keyboardDirections:
		velocity.x = keyboardDirections * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	#Attack (keyboard) 
	if Input.is_action_just_pressed("kbattack"):
		processAttackDirection()
		$Fists.attack()



## Determine which way the player is going
	#Set facingRight to true or false
func processDirection() -> void:
	if velocity.x < 0:
		facingRight = false
	elif velocity.x > 0:
		facingRight = true



## Handle if crouch punching or stand punching - part 1
	#Note: yPos is a stand in to adjust my testing fists animation according to crouch 
	#or not crouch. Later this section should instead display the crouch punch 
	#animation or standing punch animation accordingly. 
## Handle if facing left or right when punching - part 2
	#This can later be changed to just rotating the defined animation 
	#above (ie crouch punch or stand punch) according to direction 
	#player is facing
func processAttackDirection() -> void:
	## part 1
	var yPos
	if crouching == true:
		#Display crouch punch animation here
		yPos = 23
	else:
		#Display standing punch animation here
		yPos = 6
	$Fists.position.y = yPos
	
	## part 2
	if facingRight:
		#Display given animation facing to the right
		$Fists/AnimatedSprite2D.rotation = 0
		$Fists.position = Vector2(25, yPos)
	else:
		#Display given animation facing to the left
		$Fists/AnimatedSprite2D.rotation = (PI)
		$Fists.position = Vector2(-25, yPos)

#process the correct sprite frame for each frame
func playAnimation():
	if facingRight:
		if crouching:
			characterStanding.visible = false
			characterCrouching.visible = true
			characterCrouching.play("crouchingRight")
		else: 
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.play("movingRight")
	else:
		if crouching:
			characterStanding.visible = false
			characterCrouching.visible = true
			characterCrouching.play("crouchingLeft")
		else:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.play("movingLeft")

func getStunned():
	stunned = true
	$StunTimer.start()
	
func _on_stun_timer_timeout() -> void:
	stunned = false
	
##Assigns the player their controller value
func _on_ready():
	playerHealthBar.value = health
	var _controllers = Input.get_connected_joypads()
	if controllerNumber != 0 && controllerNumber != 1:
		controllerNumber = get_parent().ClaimController(self)
		
func dealDamage(amount):
	health -= amount
