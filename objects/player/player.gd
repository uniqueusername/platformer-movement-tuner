extends CharacterBody2D

func _ready():
	# send a reference of myself to the input singleton
	InputManager.connect_player(self)

func apply_inputs(input_dir: Vector2, jump_just_pressed: bool):
	$movement.apply_inputs(input_dir, jump_just_pressed)

func cancel_movement():
	$movement.cancel_movement()
