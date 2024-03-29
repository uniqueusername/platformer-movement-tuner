extends Node

# reference to player
var player: CharacterBody2D

# input values
var move_power: Vector2 # all-directional movement request
var jump_just_pressed: bool

func _physics_process(delta):
	move_power.x = clamp(Input.get_axis("player_left", "player_right"), -1.0, 1.0)
	jump_just_pressed = Input.is_action_just_pressed("player_jump")
	if player: player.apply_inputs(move_power, jump_just_pressed)

func _input(event):
	if Input.is_action_pressed("ui_cancel"): get_tree().quit()

# player node can call this to connect itself to the input manager
# input manager will send collected inputs to the player it's connected to
func connect_player(player: CharacterBody2D):
	self.player = player
