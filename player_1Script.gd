extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Select the device to connect to
@export var playerIndex = 0

@export var facingRight = true

@onready var standing_collision = $standing
@onready var crouching_collision = $crouching
@onready var crouchSprite = $"MeshInstance2D (crouch)"
@onready var standingSprite = $"MeshInstance2D (standing)"

var health = 100
var stunned = false

#for debugging, can be removed later
var prevHealth = health

var controllerNumber

func _physics_process(delta: float) -> void:
	#quit game with esc button
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	#if necessary show the health of the player only when updated
	if health != prevHealth:
		print("player health 1:", health)
		prevHealth = health
		
	#for debug purposes will be changed later, when you jump off the platform the game will close
	if health == 0:
		get_tree().change_scene_to_file("res://menu.tscn")
	
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
	
	# Check for punch input
	if Input.is_action_just_pressed("attack" + str(controllerNumber)):
		processAttackDirection()
		$Fists.attack()
	
	move_and_slide()


func processControllerInput(delta: float) -> void:
	# Ground the character faster. (controller)
	if not is_on_floor() and Input.is_action_just_pressed("down" + str(controllerNumber)):
		velocity += (get_gravity() * delta) * 25
		
	# Handle ducking (controller)
	if Input.is_action_pressed("down" + str(controllerNumber)) and is_on_floor():
		standing_collision.disabled = true
		standingSprite.visible = false
		crouching_collision.disabled = false
		crouchSprite.visible = true
	else:
		standing_collision.disabled = false
		standingSprite.visible = true
		crouching_collision.disabled = true
		crouchSprite.visible = false
	
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



func processKeyboardInput(delta: float) -> void: 
	# faster falling (keyboard)
	if not is_on_floor() and Input.is_action_just_pressed("kbDown"):
		velocity += (get_gravity() * delta) * 25
	
	# Handle ducking (keyboard)
	if Input.is_action_pressed( "kbDown") and is_on_floor():
		standing_collision.disabled = true
		standingSprite.visible = false
		crouching_collision.disabled = false
		crouchSprite.visible = true
	else:
		standing_collision.disabled = false
		standingSprite.visible = true
		crouching_collision.disabled = true
		crouchSprite.visible = false
	
	#handle jumping (keyboard)
	if Input.is_action_just_pressed("kbJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Left and right (keyboard)
	var keyboardDirections := Input.get_axis("kbLeft", "kbRight")
	if keyboardDirections:
		velocity.x = keyboardDirections * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)



## Determine which way the player is going
	#Set facingRight to true or false
func processDirection() -> void:
	var directionx := Input.get_joy_axis(controllerNumber, JOY_AXIS_LEFT_X)
	#var directiony := Input.get_joy_axis(controllerNumber, JOY_AXIS_LEFT_Y)
	var direction = directionx
	if(direction < get_parent().GetControllerNegativeDeadzone()):
		facingRight = false
	elif(direction > get_parent().GetControllerPositiveDeadzone()):
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
	if crouchSprite.visible == true:
		#Display crouch punch animation here
		yPos = 6
	else:
		#Display standing punch animation here
		yPos = -4
	$Fists.position.y = yPos
	
	## part 2
	if facingRight:
		#Display given animation facing to the right
		$Fists/AnimatedSprite2D.rotation = 0
		$Fists.position = Vector2(13, yPos)
	else:
		#Display given animation facing to the left
		$Fists/AnimatedSprite2D.rotation = (PI)
		$Fists.position = Vector2(-20, yPos)



##Assigns the player their controller value
func _on_ready():
	var controllers = Input.get_connected_joypads()
	if controllerNumber != 0 && controllerNumber != 1:
		controllerNumber = get_parent().ClaimController(self)
		print_debug(self.name, ": ", str(controllerNumber))
		if(controllers.size() > controllerNumber):
			print_debug("Controller ", controllers[controllerNumber])
