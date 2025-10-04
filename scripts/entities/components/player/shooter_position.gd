class_name ShooterPosition
extends Resource

@export_group("Position")
@export var unfocused_position: Vector2
@export var focused_position: Vector2
@export var move_speed: float = 25
@export_group("Condition")
@export var min_power: float = 0
@export var max_power: float = 500
