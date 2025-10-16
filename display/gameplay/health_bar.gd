class_name HealthBar
extends TextureProgressBar

@export var character : Character

var target_alpha : float = 0.0

func _ready() -> void:
	modulate.a = 0.0
	min_value = 0

func _physics_process(delta: float) -> void:
	update_value(delta)
	
func start_display():
	value = 0.0
	target_alpha = 1.0

func end_display():
	target_alpha = 0.0

func update_value(delta):
	max_value = character.mhp
	# Temporary
	if value <= 0.1:
		target_alpha = 0.0
	else:
		target_alpha = 1.0
	modulate.a = MathUtils.lerp_smooth(modulate.a, target_alpha, 20, delta)
	value = MathUtils.lerp_smooth(value, float(character.hp), 20, delta)
