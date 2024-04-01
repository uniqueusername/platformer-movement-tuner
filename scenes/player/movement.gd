# movement component script for CharacterBody2D
extends Node2D

# reference to parent node (player)
@onready var p: CharacterBody2D = get_parent()
@export var sprite: AnimatedSprite2D
var animated: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# input variables
var input_dir: Vector2 = Vector2.ZERO # max magnitude 1.0
var jump_just_pressed: bool = false

# movement constants
@export_group("movement configuration")
@export_subgroup("ground movement")
@export var start_accel: float = 800
@export var max_speed: float = 1200
@export var stop_accel: float = 400

@export_subgroup("air movement")
@export var first_half_grav: float = 980
@export var second_half_grav: float = 980
var jump_speed: float = 600 # calculated from height
@export var jump_height: float = 96:
	get: return jump_height
	set(value):
		jump_height = value
		calculate_jump(value)
@export var air_strafe_multiplier: float = 0.2

func _ready():
	animated = sprite != null
	calculate_jump(jump_height)
	print(jump_height)

func _physics_process(delta):
	update_velocities(input_dir, jump_just_pressed, delta)
	if animated: animate(input_dir.x, p.is_on_floor(), sprite)
	p.move_and_slide()

# input objects can call this to send inputs to this player
func apply_inputs(input_dir: Vector2, jump_just_pressed: bool):
	self.input_dir = input_dir
	self.jump_just_pressed = jump_just_pressed

# update character velocities for one frame based on inputs
func update_velocities(dir: Vector2, jump: bool, delta: float):
	# apply gravity
	if (p.velocity.y < 0): # going up
		p.velocity.y += first_half_grav * delta
	else: # going down 
		p.velocity.y += second_half_grav * delta
	
	# horizontal movement
	## multiply movespeed if air-strafing
	var multiplier = 1.0 if $ground_ray.is_colliding() else air_strafe_multiplier
	
	if dir:
		# change directions at start rate
		# makes counterstrafing possible
		p.velocity.x = lerpf(p.velocity.x, 
							 dir.x * max_speed, 
							 start_accel / max_speed * multiplier)
	else:
		# only use stop rate for stopping
		p.velocity.x = lerpf(p.velocity.x, 0, 
							 stop_accel / max_speed * multiplier)
		
	# jumping
	if jump and p.is_on_floor():
		p.velocity.y = -jump_speed

# calculate jump velocity based on desired jump height
func calculate_jump(jump_height: float):
	jump_speed = sqrt(2 * first_half_grav * jump_height)

# animate sprite based on status
# expects "run", "idle", and "jump" animations
func animate(x_input: float, on_floor: bool, sprite: AnimatedSprite2D):
	if abs(x_input) > 0: sprite.play("run")
	else: sprite.play("idle")
	
	if x_input > 0: sprite.flip_h = true
	elif x_input < 0: sprite.flip_h = false
	
	if !on_floor: sprite.play("jump")
