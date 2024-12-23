extends Area2D

var KNOCKBACK_MODIFIER = 0.0
#unnecessary variable
var DAMAGE_PER_HIT = 20
const FORWARD_MOMENTUM = 150
var DamageToDeal = 1

var bigHit = false

var canAttack = true


var stunnedPlayer
var setInputBuffer = 0.0

@onready var chickenSound = $RubberChicken
@onready var collShape = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$RightHit.visible = false
	$LeftHit.visible = false
	$CrouchRight.visible = false
	$CrouchLeft.visible = false
	$UpRight.visible = false
	$UpLeft.visible = false
	$CollisionShape2D.disabled = true

# Player punches
func startDisplayTimer() -> void: 
	#Begin displaying punch animation 
	if get_parent().facingRight:
		if get_parent().crouching:
			$CrouchRight.visible = true
		elif get_parent().facingUpwards:
			$UpRight.visible = true
		else:
			$RightHit.visible = true
	else:
		if get_parent().crouching:
			$CrouchLeft.visible = true
		elif get_parent().facingUpwards:
			$UpLeft.visible = true
		else:
			$LeftHit.visible = true
	
	#Begin collision
	$CollisionShape2D.disabled = false;
	#Start the displaytimer
	$displayTimer.start()

# Player cant punch
func startInputBuffer() -> void: 
	#Start the InputBuffer
	$inputBuffer.start()
	canAttack = false

# Player can punch
func _on_input_buffer_timeout():
	canAttack = true

# Player isn't punching
func _on_display_timer_timeout():
	#Stop displaying the punch animation
	$RightHit.visible = false
	$LeftHit.visible = false
	$CrouchRight.visible = false
	$CrouchLeft.visible = false
	$UpRight.visible = false
	$UpLeft.visible = false
	
	#Stop collision
	$CollisionShape2D.disabled = true



# NOTE: player in this context is the one dealing the damage
#      body is the player recieving the damage
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		# Only apply punch if they are not the owner of the fists
		if get_parent().name != body.name:
			var knockback_direction = ($CollisionShape2D.global_position - body.global_position).normalized()
			var velocity = knockback_direction * DAMAGE_PER_HIT * KNOCKBACK_MODIFIER
			body.velocity = velocity * -1.25
			body.getStunned()
			body.move_and_slide()
			
			#Deal 2 times as much damage as last time
			body.dealDamage(DamageToDeal)
			DamageToDeal *= 1.5
			
			#play the rubber chicken noise
			$Whiff.stop()
			chickenSound.play()
			
			#Reverse the players controls as well as create a flash on the screen
			if bigHit:
				body.getConcussed()
				ConcussedEffect.playConcussedEffect()



## Handle if crouch punching or stand punching - part 1
	#Note: yPos is a stand in to adjust my testing fists animation according to crouch 
	#or not crouch. Later this section should instead display the crouch punch 
	#animation or standing punch animation accordingly. 
## Handle if facing left or right when punching - part 2
	#This can later be changed to just rotating the defined animation 
	#above (ie crouch punch or stand punch) according to direction 
	#player is facing
# Begin punch cooldown (buffer) and use displayTimer
# displayTimer temp shows punch animation & allows collision
func attack() -> void:
	
	if canAttack:
		$Whiff.play()
		## part 1
		var yPos
		if get_parent().crouching == true:
			#Display crouch punch animation here
			yPos = 23
		else:
			#Display standing punch animation here
			yPos = 6
		$CollisionShape2D.position.y = yPos
		
			#check for a concussive attack
		if get_parent().facingUpwards:
			bigHit = true
		else:
			bigHit = false
	
		## part 2
		if get_parent().facingRight:
			#Display given animation facing to the right
			$CollisionShape2D.rotation = PI/2
			$CollisionShape2D.position = Vector2(30, yPos)
			
			#check if up + attack
			if get_parent().facingUpwards && not get_parent().crouching:
				
				$CollisionShape2D.rotation = PI/1.7
				$CollisionShape2D.position.x -= 10
				$CollisionShape2D.position.y += 30

				setInputBuffer = 1.5
				KNOCKBACK_MODIFIER = 20
				
				DamageToDeal = 4
			
			#check for crouch + attack
			elif get_parent().crouching:
				$CollisionShape2D.position.x = 70
				$CollisionShape2D.position.y = 35
				
				setInputBuffer = 1
				KNOCKBACK_MODIFIER = 30
				
			#regular attack
			else:
				$CollisionShape2D.position.y = -10
				
				setInputBuffer = 0.5
				KNOCKBACK_MODIFIER = 100
		else:
			#Display given animation facing to the left
			$CollisionShape2D.rotation = (PI/2)
			$CollisionShape2D.position = Vector2(-30, yPos)
			
			# check if up + attack
			if get_parent().facingUpwards &&  not get_parent().crouching:
				$CollisionShape2D.rotation = -(PI/1.7)
				$CollisionShape2D.position.x += 10
				$CollisionShape2D.position.y += 30
				
				setInputBuffer = 1.5
				KNOCKBACK_MODIFIER = 20
				
				DamageToDeal = 4
				
			# Check is crouching + attack
			elif get_parent().crouching:
				$CollisionShape2D.position.x = -70
				$CollisionShape2D.position.y = 35
				
				setInputBuffer = 1.0
				KNOCKBACK_MODIFIER = 30

			# normal attack
			else:
				$CollisionShape2D.position.y = -10
				
				setInputBuffer = 0.5
				KNOCKBACK_MODIFIER = 100

		# Display the animation for attacking with Fists
		
		startDisplayTimer()
		
		# Diable inputs temporarily for player who attacked (avoid rapid fire)
		$inputBuffer.wait_time = setInputBuffer
		
		startInputBuffer()
		# Make the player move forward from punching
		ProcessForwardMomentum()



# Process forward momentum from the punch
func ProcessForwardMomentum() -> void:
	var player = get_parent()
	var lunge_direction = (player.global_position - $CollisionShape2D.global_position).normalized()
	player.velocity.x = lunge_direction.x * FORWARD_MOMENTUM * -10
	player.move_and_slide()
