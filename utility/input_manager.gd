extends Node

# reference to player
var player: CharacterBody2D

# input values
var move_power: Vector2

func _process(delta):
	move_power.x = clamp(Input.get_axis("player_left", "player_right"), -1.0, 1.0)
	
	if player: player.apply_inputs(move_power, false)

func _input(event):
	if Input.is_action_pressed("ui_cancel"): get_tree().quit()

func connect_player(player: CharacterBody2D):
	self.player = player
