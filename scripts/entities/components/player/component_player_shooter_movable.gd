class_name ComponentPlayerShooterMovable
extends ComponentPlayerShooter

@export var layout_positions: Array[ShooterPosition]

func _physics_process(delta: float) -> void:
	GameVariables.add_power()
	process_movement(delta)
	super(delta)
	
func process_movement(delta: float) -> void:
	var sh_pos: ShooterPosition = get_target_position()
	if sh_pos == null:
		return
	
	if Input.is_action_pressed("focus"):
		entity.position = MathUtils.lerp_smooth(entity.position, sh_pos.focused_position, sh_pos.move_speed, delta)
	else:
		entity.position = MathUtils.lerp_smooth(entity.position, sh_pos.unfocused_position, sh_pos.move_speed, delta)
	
func get_target_position() -> ShooterPosition:
	for sh_pos: ShooterPosition in layout_positions:
		if GameVariables.power >= sh_pos.min_power and GameVariables.power <= sh_pos.max_power:
			return sh_pos
	return null
