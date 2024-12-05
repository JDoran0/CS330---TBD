extends CharacterBody2D


const SPEED = 300.0
const FRICTION_EFFECT_MAX_SPEED = 50.0
const JUMP_VELOCITY = -400.0

# Select the device to connect to
@export var playerIndex = 0
var controllerNumber

#checking current character position
var facingRight = true
var facingUpwards = false
var crouching = false
var isPunching = false
var punchCooldown = false
var stunned = false
var concussed = false
var recoveredFromConcussed = false

@export var frictionFactor = 0.005
@export var crouchSpeed = 0.5

#two seperate collision boxes for different collision modes
@onready var standing_collision = $standing
@onready var crouching_collision = $crouching

# Visual sprites
@onready var characterStanding = $"Character(standing)"
@onready var characterCrouching = $"Character(crouching)"
@onready var playerHealthBar = $"../CanvasLayer/Player1HB"

var health = 100

# for updating player health
var prevHealth = health



func _physics_process(delta: float) -> void:
	
	# Process current animation
	playAnimation()
	
	# update the health of the player
	if health != prevHealth:
		#print("player health 1:", health)
		prevHealth = health
		playerHealthBar.value = health
	
	if health <= 0:
		get_tree().change_scene_to_file("res://GamePlay--menus/game_over.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# check if stunned and if assgined a controller or keyboard
	if !stunned && controllerNumber != -1:
		processControllerInput(delta)
	
	if !stunned && controllerNumber == -1:
		processKeyboardInput(delta)
	
	#Determine which way the player is facing
	processDirection()
	
	move_and_slide()

# Handling controller inputs for player 1
func processControllerInput(delta: float) -> void:
	
	# Ground the character faster. (controller)
	if not is_on_floor() and Input.is_action_just_pressed("down" + str(controllerNumber)):
		velocity += (get_gravity() * delta) * 35

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
		if concussed:
			direction *= -1
		if recoveredFromConcussed:
			direction *= -1
			recoveredFromConcussed = false
		
		if crouching:
			velocity.x = direction * SPEED * crouchSpeed
		else:
			velocity.x = direction * SPEED

	elif directionDPad > controllerDeadzonePos || directionStick > controllerDeadzonePos:
		var direction = max(directionStick, directionDPad)
		if concussed:
			direction *= -1
		if recoveredFromConcussed:
			direction *= -1
			recoveredFromConcussed = false

		if crouching:
			velocity.x = direction * SPEED * crouchSpeed
		else:
			velocity.x = direction * SPEED
	else:
		if Global.prevCard == "Last" and (velocity.x < FRICTION_EFFECT_MAX_SPEED or velocity.x > FRICTION_EFFECT_MAX_SPEED * -1):
			velocity.x = move_toward(velocity.x, 0, SPEED * frictionFactor)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Check if looking upwards BEFORE processAttackDirection() 
	if Input.is_action_pressed("up" + str(controllerNumber)):
		facingUpwards = true
	else:
		facingUpwards = false
	
	# Check for punch input (controller)
	if Input.is_action_just_pressed("attack" + str(controllerNumber)):
			
		if !punchCooldown:
			punchCooldown = true
			isPunching = true
			$PunchTimer.start()
			$PunchCooldownTimer.start()
			
		#CHECK WHICH WEAPON USING HERE
		if Global.weaponType == "Chicken":
			$Chicken.attack()
		elif Global.weaponType == "Gun":
			$Gun.shoot()
		elif Global.weaponType == "OnePunch":
			$Fists.attack()
			Global.DAMAGE_PER_HIT = 1000
		else:
			$Fists.attack()

# Handling keyboard inputs for player 1
func processKeyboardInput(delta: float) -> void: 
	# Faster falling (keyboard)
	if not is_on_floor() and Input.is_action_just_pressed("kbDown"):
		velocity += (get_gravity() * delta) * 35
	
	# Handle ducking (keyboard)
	if Input.is_action_pressed( "kbDown") and is_on_floor():
		crouching = true
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		crouching = false
		standing_collision.disabled = false
		crouching_collision.disabled = true
	
	# Handle jumping (keyboard)
	if Input.is_action_just_pressed("kbJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Left and right (keyboard)
	var keyboardDirections := Input.get_axis("kbLeft", "kbRight")
	
	if concussed:
		keyboardDirections *= -1
	if recoveredFromConcussed:
		keyboardDirections *= -1
		recoveredFromConcussed = false
		
	if keyboardDirections:
		if crouching:
			velocity.x = keyboardDirections * SPEED * crouchSpeed
		else:
			velocity.x = keyboardDirections * SPEED
	else:
		if Global.prevCard == "Last" and (velocity.x < FRICTION_EFFECT_MAX_SPEED or velocity.x > FRICTION_EFFECT_MAX_SPEED * -1):
			velocity.x = move_toward(velocity.x, 0, SPEED * frictionFactor)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Check if looking upwards BEFORE processAttackDirection() 
	if Input.is_action_pressed("kbUp"):
		facingUpwards = true
	else:
		facingUpwards = false

	# Attack (keyboard) 
	if Input.is_action_just_pressed("kbattack"):
			
		if !punchCooldown:
			punchCooldown = true
			isPunching = true
			$PunchTimer.start()
			$PunchCooldownTimer.start()
	
		#CHECK WHICH WEAPON USING HERE
		if Global.weaponType == "Chicken":
			$Chicken.attack()
		elif Global.weaponType == "Gun":
			$Gun.shoot()
		elif Global.weaponType == "OnePunch":
			$Fists.attack()
			Global.DAMAGE_PER_HIT = 1000
		else:
			$Fists.attack()



# Determine which way the player is going
func processDirection() -> void:
	if velocity.x < 0:
		facingRight = false
	elif velocity.x > 0:
		facingRight = true

#process the correct sprite frame for each frame
func playAnimation():
	if Global.weaponType == "Chicken":
		$Chicken.visible = true
	elif Global.weaponType == "Gun":
		$Gun.visible = true
	elif isPunching:
		if facingUpwards:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.play("UppercutRight")
		elif crouching:
			characterStanding.visible = false
			characterCrouching.visible = true
			characterCrouching.play("crouchPunchRight")
		else:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.play("PunchRight")
		return
	
	if stunned:
		characterStanding.visible = true
		characterCrouching.visible = false
		characterStanding.flip_h = not facingRight
		characterStanding.play("Stun")
		return
	elif facingRight:
		if crouching:
			characterStanding.visible = false
			characterCrouching.visible = true
			characterCrouching.flip_h = false
			characterCrouching.play("crouchingRight")
		elif velocity.x > 0:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.flip_h = false
			characterStanding.play("movingRight")
		else:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.flip_h = false
			characterStanding.frame = 0
	else:
		if crouching:
			characterStanding.visible = false
			characterCrouching.visible = true
			characterCrouching.flip_h = true
			characterCrouching.play("crouchingRight")
		elif velocity.x < 0:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.flip_h = true
			characterStanding.play("movingRight")
		else:
			characterStanding.visible = true
			characterCrouching.visible = false
			characterStanding.flip_h = true
			characterStanding.frame = 0
	if Global.weaponType != "Gun":
		$Gun.visible = false
	if Global.weaponType != "Chicken":
		$Chicken.visible = false


# Stun the player for an appropriate time
func getStunned():
	stunned = true
	$StunTimer.start()
	

# Remove the stun
func _on_stun_timer_timeout() -> void:
	stunned = false
	
#Assigns the player their controller value
func _on_ready():
	if controllerNumber != 0 && controllerNumber != 1:
		controllerNumber = get_parent().ClaimController(self)

# Process dealt damage from other entities
func dealDamage(amount):   
	health -= amount

# concuss the player
func getConcussed():
	concussed = true
	$ConcussedTimer.start()

# remove the concussed effect
func _on_concussed_timer_timeout() -> void:
	concussed = false
	recoveredFromConcussed = true
	
func _on_punch_timer_timeout() -> void:
	isPunching = false

func _on_punch_cooldown_timer_timeout() -> void:
	punchCooldown = false
