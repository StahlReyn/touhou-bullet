class_name Shooter
extends Entity

@export var following_entity: Entity
@export var layout_positions: Array[ShooterPosition]

var modulate_spawn: Color = Color(150,150,150,150)
var modulate_normal: Color = Color(1,1,1,1)
var modulate_decay: float = 20

func _ready() -> void:
	# If there is following entity specified, make it top level following
	if following_entity != null:
		top_level = true
		global_position = following_entity.global_position

func _physics_process(delta: float) -> void:
	process_movement(delta)
	
func process_movement(delta: float) -> void:
	var sh_pos: ShooterPosition = get_target_position()
	if sh_pos == null:
		visible = false
		return
	
	if !visible: # Just appeared, set location
		global_position = following_entity.global_position + sh_pos.unfocused_position
		visible = true
		modulate = modulate_spawn
	
	modulate = MathUtils.lerp_smooth(modulate, modulate_normal, modulate_decay, delta)
	
	if Input.is_action_pressed("focus"):
		global_position = MathUtils.lerp_smooth(
			global_position, 
			following_entity.global_position + sh_pos.focused_position, 
			sh_pos.move_speed, 
			delta
		)
	else:
		global_position = MathUtils.lerp_smooth(
			global_position, 
			following_entity.global_position + sh_pos.unfocused_position, 
			sh_pos.move_speed, 
			delta
		)
	
func get_target_position() -> ShooterPosition:
	var highest_sh: ShooterPosition = null
	var highest_power: int = 0
	for sh_pos: ShooterPosition in layout_positions:
		if GameVariables.power >= sh_pos.min_power && GameVariables.power > highest_power:
			highest_sh = sh_pos
			highest_power = sh_pos.min_power
	return highest_sh
