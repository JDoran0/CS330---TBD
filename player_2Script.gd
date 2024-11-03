extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Select the device to connect to
@export var playerIndex = 1

@onready var standing_collision = $standing
@onready var crouching_collision = $crouching
@onready var crouchSprite = $"MeshInstance2D (crouch)"
@onready var standingSprite = $"MeshInstance2D (standing)"

var health = 100

#for debugging, can be removed later
var prevHealth = health


func _physics_process(delta: float) -> void:
	
	#quit game with esc button
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	#if necessary show the health of the player only when updated
	if health != prevHealth:
		print("player health 2:", health)
		prevHealth = health
		
	#for debug purposes will be changed later, when you jump off the platform the game will close
	if health == 0:
		get_tree().change_scene_to_file("res://menu.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Ground the character faster. (controller)
	if not is_on_floor() and Input.is_action_just_pressed("down" + str(playerIndex)):
		velocity += (get_gravity() * delta) * 25
	
	# Handle ducking (controller)
	if Input.is_action_pressed("down" + str(playerIndex)) and is_on_floor():
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
	if Input.is_action_just_pressed("jump" + str(playerIndex)) and is_on_floor():
		velocity.y = JUMP_VELOCITY	

	# moving left and right for player2 (controller)
	var direction := Input.get_axis("left" + str(playerIndex), "right" + str(playerIndex))
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# hand ducking (keyboard)
	if Input.is_action_pressed("kbDown") and is_on_floor():
		standing_collision.disabled = true
		standingSprite.visible = false
		crouching_collision.disabled = false
		crouchSprite.visible = true
	else:
		standing_collision.disabled = false
		standingSprite.visible = true
		crouching_collision.disabled = true
		crouchSprite.visible = false
	
	# falling faster (keyboard)
	if not is_on_floor() and Input.is_action_just_pressed("kbDown"):
		velocity += (get_gravity() * delta) * 25
	
	# handle jumping (keyboard)
	if Input.is_action_just_pressed("kbJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Left and right (keyboard)
	var keyboardDirections := Input.get_axis("kbLeft", "kbRight")
	if keyboardDirections:
		velocity.x = keyboardDirections * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	


	move_and_slide()
