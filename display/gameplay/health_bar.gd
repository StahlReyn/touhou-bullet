class_name HealthBar
extends TextureProgressBar

@export var character: Character

@onready var base_marker: Sprite2D = $MarkerBase
var markers: Array[Sprite2D]

var target_alpha: float = 0.0

func _ready() -> void:
	modulate.a = 0.0
	min_value = 0
	base_marker.visible = false

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

func add_marker(hp: float) -> void:
	var marker = base_marker.duplicate()
	# Quarter as angle start pointing RIGHT while hp bar starts UP
	marker.rotation = ((hp / character.mhp) + 0.25) * TAU
	marker.visible = true
	add_child(marker)
	markers.push_back(marker)

func clear_markers() -> void:
	while markers.size() > 0:
		var sprite: Sprite2D = markers.pop_back()
		sprite.queue_free()
