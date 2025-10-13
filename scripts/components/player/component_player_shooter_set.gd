class_name ComponentPlayerShooterSet
extends EntityComponent

@export var layout: Dictionary[Entity, ShooterPosition]
@export var min_power: int = 0
@export var max_power: int = 500
@export var focus_anim_speed: float = 25

func _physics_process(delta: float) -> void:
	if GameVariables.power < min_power or GameVariables.power > max_power:
		return
	
	if Input.is_action_pressed("focus"):
		for en: Entity in layout:
			var pos: ShooterPosition = layout[entity]
			en.position = MathUtils.lerp_smooth(entity.position, pos.focused_position, focus_anim_speed, delta)
	else:
		for en: Entity in layout:
			var pos: ShooterPosition = layout[entity]
			en.position = MathUtils.lerp_smooth(entity.position, pos.unfocused_position, focus_anim_speed, delta)
	
