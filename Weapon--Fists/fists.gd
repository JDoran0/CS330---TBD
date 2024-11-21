extends Area2D

const KNOCKBACK_MODIFIER = 400.0
const DAMAGE_PER_HIT = 10
const FORWARD_MOMENTUM = 100

var canAttack = true
var stunnedPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true

# Player punches
func startDisplayTimer() -> void: 
	#Begin displaying punch animation 
	$AnimatedSprite2D.visible = true
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
	$AnimatedSprite2D.visible = false
	#Stop collision
	$CollisionShape2D.disabled = true



# NOTE: player in this context is the one dealing the damage
#      body is the player recieving the damage
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		# Only apply punch if they are not the owner of the fists
		if get_parent().name != body.name:
			#var knockback_direction = (global_position - body.global_position).normalized()
			#var velocity = knockback_direction * DAMAGE_PER_HIT * KNOCKBACK_MODIFIER
			#body.velocity = velocity * -1.25
			var fistPosition = global_position
			if body.facingUpwards:
				fistPosition.y = body.position.y - 200
				body.applyKnockback(KNOCKBACK_MODIFIER, fistPosition)
			else:
				fistPosition.y = body.position.y
				body.applyKnockback(KNOCKBACK_MODIFIER, fistPosition)
			body.getStunned()
			body.move_and_slide()
			body.dealDamage(DAMAGE_PER_HIT)



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
		## part 1
		var yPos
		if get_parent().crouching == true:
			#Display crouch punch animation here
			yPos = 23
		else:
			#Display standing punch animation here
			yPos = 6
		position.y = yPos
	
		## part 2
		if get_parent().facingRight:
			#Display given animation facing to the right
			rotation = 0
			position = Vector2(30, yPos)
			if get_parent().facingUpwards && not get_parent().crouching:
				rotation = -PI/3
				position.y -= 5
			else:
				rotation = 0
		else:
			#Display given animation facing to the left
			rotation = (PI)
			position = Vector2(-30, yPos)
			if get_parent().facingUpwards &&  not get_parent().crouching:
				rotation = -2*PI/3
				position.y -= 5
			else:
				rotation = (PI)
		
		# Display the animation for attacking with Fists
		startDisplayTimer()
		# Diable inputs temporarily for player who attacked (avoid rapid fire)
		startInputBuffer()
		# Make the player move forward from punching
		ProcessForwardMomentum()



# Process forward momentum from the punch
func ProcessForwardMomentum() -> void:
	var player = get_parent()
	var lunge_direction = (player.global_position - global_position).normalized()
	player.velocity.x = lunge_direction.x * FORWARD_MOMENTUM * -10
	player.move_and_slide()
