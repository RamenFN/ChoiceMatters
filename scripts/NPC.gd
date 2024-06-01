extends CharacterBody2D

# Constants for states
enum { WALKIN, IDLE, HAPPY, WALKBACK, OFFSCREEN }

# Speed of movement
const SPEED = 30

# Current state and direction
var current_state = WALKIN
var dir = Vector2.LEFT
var target_position = Vector2.ZERO  # Add a target position

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

# On ready, randomize the seed and set initial target position
func _ready():
	randomize()
	target_position = Vector2(100, position.y)  # Set the initial target position
	
func _input(event):
	if event.is_action_pressed("approve") && current_state == IDLE:
		current_state = HAPPY
	elif event.is_action_pressed("disapprove") && current_state == IDLE:
		current_state = WALKBACK
# Physics process function to handle movement
func _physics_process(delta):
	match current_state:
		IDLE:
			if animated_sprite:
				animated_sprite.play("idle")
			else:
				print("Error: AnimatedSprite2D not found")
		HAPPY:
			if animated_sprite:
				animated_sprite.play("happy")
			else:
				print("Error: AnimatedSprite2D not found")
		WALKBACK:
			dir = Vector2.RIGHT
			animated_sprite.flip_h = false
			animated_sprite.play("walk")
			target_position = Vector2(243, position.y)
			move_to_target()
		WALKIN:
			dir = Vector2.LEFT
			animated_sprite.flip_h = true
			move_to_target()
			if position.distance_to(target_position) == 1.5:
				print("Starting dialouge")

# Move function to handle movement
func move_to_target():
	if position.distance_to(target_position) > 1:
		velocity = dir * SPEED
		move_and_slide()
	else:
		current_state = IDLE
		velocity = Vector2.ZERO  # Stop the character

# Function called when the Timer times out
func _on_Timer_timeout():
	if timer:
		timer.wait_time = choose([1, 2, 2.5])
		timer.start()  # Restart the timer
	else:
		print("Error: Timer not found")
	

# Choose function to pick a random element from an array
func choose(array):
	return array[randi() % array.size()]
