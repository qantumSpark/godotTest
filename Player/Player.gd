extends KinematicBody2D


# Phisics Parameters
var FRICTION = 3000
var ACCELERATION = 500
var MAX_SPEED = 80
var ROLL_SPEED = MAX_SPEED * 1.5
enum {
	MOVE,
	ROLL,
	ATTACK
}

# "STATS"
var isOnRoad = false
var state = MOVE
var roll_vector = Vector2.DOWN
var knockback = 50

# Init mouvement Vector
var velocity = Vector2.ZERO

# Import Animation 
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

# Wait for player to be loaded before starting the animation
func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector


# CallBack at each update // delta: time passed since last update
func _physics_process(delta):
	
	# Point to function after checking the sate
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	# Checking input and changing state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move_state(delta):
	
	# Vector d'input between 0 & 1
	var input_vector = Vector2.ZERO
	
	#Check Input key 
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	 
	#Force diagonal speed to be the same
	input_vector = input_vector.normalized()
	
	#Check if Player is on road
	if isOnRoad:
		MAX_SPEED = 120
	else:
		MAX_SPEED = 80
	
	#Update Position and Animation
		#If Moving
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		#Define Animation With Animation State and vector direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		
		#Update velocity and direction following the input vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		#No input, player come to a stop
	else: 
		animationState.travel("Idle")
		#Slow movements to stop
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#Move the player on screen
	move()
	
	


func move():
	velocity = move_and_slide(velocity)


func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

# Methods call by the animation with signals

func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
