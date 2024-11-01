extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
		print("player health:", health)
		prevHealth = health
		
	#for debug purposes will be changed later, when you jump off the platform the game will close
	if health == 0:
		get_tree().change_scene_to_file("res://menu.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Ground the character faster.
	if not is_on_floor() and Input.is_action_just_pressed("ui_down"):
		velocity += (get_gravity() * delta) * 25
		
	 
	if Input.is_action_pressed( "ui_down"):
		standing_collision.disabled = true
		standingSprite.visible = false
		crouching_collision.disabled = false
		crouchSprite.visible = true
	else:
		standing_collision.disabled = false
		standingSprite.visible = true
		crouching_collision.disabled = true
		crouchSprite.visible = false
		 

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
