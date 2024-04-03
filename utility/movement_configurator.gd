extends VBoxContainer

# movement component to send config too
@export var movement: Node2D

# slider values
var start_accel: float
var stop_accel: float
var max_speed: float
var jump_height: float
var first_half_grav: float
var second_half_grav: float
var air_strafe_multiplier: float

func send_config():
	if movement:
		movement.update_config(
			start_accel,
			stop_accel,
			max_speed,
			jump_height,
			first_half_grav,
			second_half_grav,
			air_strafe_multiplier
		)

func _on_start_accel_value_changed(value):
	start_accel = value
	send_config()

func _on_stop_accel_value_changed(value):
	stop_accel = value
	send_config()

func _on_max_speed_value_changed(value):
	max_speed = value
	send_config()

func _on_jump_height_value_changed(value):
	jump_height = value
	send_config()

func _on_first_half_grav_value_changed(value):
	first_half_grav = value
	send_config()

func _on_second_half_grav_value_changed(value):
	second_half_grav = value
	send_config()

func _on_air_strafe_multiplier_value_changed(value):
	air_strafe_multiplier = value
	send_config()
