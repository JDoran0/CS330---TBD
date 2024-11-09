extends Area2D

@export var knockbackModifier = 0.5

const DAMAGE_PER_HIT = 20
const FORWARD_MOMENTUM = 20

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
	
	# Make the player move forward from punching
	ProcessForwardMomentum()

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



#NOTE: player in this context is the one dealing the damage
#      body is the player recieving the damage
func _on_body_entered(body):
	#Check to see who owns this instance of Fists
	var player = get_parent()
	
	# Player 1 attacks Player 2
	if(player.name == "Player1" && body.name == "Player2"):
		# Process damage
		ApplyDamage(body, DAMAGE_PER_HIT)
		# Process knockback (move opposite direction of hit)
		ApplyKnockback(body, player, DAMAGE_PER_HIT)
		DisableInput(body)
	
	# Player 2 attacks Player 1
	if(player.name == "Player2" && body.name == "Player1"): 
		# Process damage
		ApplyDamage(body, DAMAGE_PER_HIT)
		# Process knockback (move opposite direction of hit)
		ApplyKnockback(body, player, DAMAGE_PER_HIT)
		DisableInput(body)



## Begin punch cooldown (buffer) and use displayTimer
	#displayTimer temp shows punch animation & allows collision
func attack() -> void:
	if canAttack:
		startDisplayTimer()
		startInputBuffer()



## Process forward momentum from the punch
func ProcessForwardMomentum() -> void:
	var player = get_parent()
	if(player.facingRight):
		player.global_position.x += FORWARD_MOMENTUM
	else:
		player.global_position.x -= FORWARD_MOMENTUM 



##Applies a knockback to damagedPlayer
	#damagedPlayer: The player recieving the knockback effect
	#damageSourcePosition: The source of the damage (uses source's location)
func ApplyKnockback(damagedPlayer, damageSource, damage: int) -> void:
	var knockbackDirection = damageSource.global_position.direction_to(damagedPlayer.global_position)
	var knockbackStrength = damage * knockbackModifier
	var knockback = knockbackDirection * knockbackStrength
	
	damagedPlayer.global_position += knockback



##Applies damaged to the damagedPlayer
func ApplyDamage(damagedPlayer, damage: int) -> void:
	damagedPlayer.health -= damage
	if(damagedPlayer.health <= 0):
		pass
		#
		#ADD: DEAL WITH DEATH MECHANICS HERE?
		#


##Disables all input of the player passed as a argument
func DisableInput(player) -> void:
	stunnedPlayer = player
	stunnedPlayer.stunned = true
	$stunTimer.start()


func _on_stun_timer_timeout():
	stunnedPlayer.stunned = false
