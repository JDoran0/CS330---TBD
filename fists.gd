extends Area2D

const KNOCKBACK_MODIFIER = 2.0
const DAMAGE_PER_HIT = 20
const FORWARD_MOMENTUM = 500

var canAttack = true
var stunnedPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func startDisplayTimer() -> void: 
	#Begin displaying punch animation 
	$AnimatedSprite2D.visible = true
	#Begin collision
	$CollisionShape2D.disabled = false;
	#Start the displaytimer
	$displayTimer.start()

func startInputBuffer() -> void: 
	#Start the InputBuffer
	$inputBuffer.start()
	canAttack = false

func _on_input_buffer_timeout():
	canAttack = true

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
			var knockback_direction = (global_position - body.global_position).normalized()
			var velocity = knockback_direction * DAMAGE_PER_HIT * KNOCKBACK_MODIFIER
			body.velocity = velocity * -1
			body.getStunned()
			body.move_and_slide()
			body.dealDamage(DAMAGE_PER_HIT)



## Begin punch cooldown (buffer) and use displayTimer
	#displayTimer temp shows punch animation & allows collision
func attack() -> void:
	if canAttack:
		# Display the animation for attacking with Fists
		startDisplayTimer()
		# Diable inputs temporarily for player who attacked (avoid rapid fire)
		startInputBuffer()
		# Make the player move forward from punching
		ProcessForwardMomentum()



## Process forward momentum from the punch
func ProcessForwardMomentum() -> void:
	var player = get_parent()
	var lunge_direction = (player.global_position - global_position).normalized()
	player.velocity.x = lunge_direction.x * FORWARD_MOMENTUM * -1
	player.move_and_slide()
