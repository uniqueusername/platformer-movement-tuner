# movement component script for CharacterBody2D
extends Node

# reference to parent node (player)
@onready var p: CharacterBody2D = get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# input variables
var input_dir: Vector2 = Vector2.ZERO # max magnitude 1.0
var jump_just_pressed: bool = false # true if currently being pressed

# movement constants
## ground movement
var start_accel: float = 800
var max_speed: float = 1200
var stop_accel: float = 400

## air movement
var jump_speed: float = 600

func _physics_process(delta):
	update_velocities(input_dir, jump_just_pressed, delta)
	p.move_and_slide()

# input objects can call this to send inputs to this player
func apply_inputs(input_dir: Vector2, jump_just_pressed: bool):
	self.input_dir = input_dir
	self.jump_just_pressed = jump_just_pressed

# update character velocities for one frame based on inputs
func update_velocities(dir: Vector2, jump: bool, delta: float):
	# apply gravity
	p.velocity.y += gravity * delta
	
	# horizontal movement
	if dir: 
		# change directions at start rate
		# makes counterstrafing possible
		p.velocity.x = lerpf(p.velocity.x, dir.x * max_speed, start_accel / max_speed)
	else:
		# only use stop rate for stopping
		p.velocity.x = lerpf(p.velocity.x, 0, stop_accel / max_speed)
		
	# jumping
	if jump and p.is_on_floor():
		p.velocity.y = -jump_speed
