class_name DeathClearEffect
extends TempEffect

const MAIN_SCENE: PackedScene = preload("res://data/effects/death_clear_effect.tscn")

@onready var shockwave: ColorRect = $BackBufferCopy/Shockwave
@onready var shockwave_shader: ShaderMaterial = shockwave.material
@onready var viewport_size: Vector2 = get_viewport_rect().size
var radius: float = 0.01

static func create(pos: Vector2) -> void:
	var effect: DeathClearEffect = MAIN_SCENE.instantiate()
	effect.top_level = true
	effect.global_position = pos
	GameVariables.game_area.add_child(effect)

func _ready() -> void:
	shockwave_shader.set_shader_parameter("radius", radius)
	shockwave_shader.set_shader_parameter("center", global_position / viewport_size)

func _physics_process(delta: float) -> void:
	radius += delta * 2
	
	shockwave_shader.set_shader_parameter("radius", radius)
	shockwave_shader.set_shader_parameter("center", global_position / viewport_size)
	
	var max_dist_sq = (radius * viewport_size.x) ** 2
	for bullet: Bullet in GameUtils.get_bullet_list():
		if not bullet.collision_mask & GameArea.Collision.PLAYER: # Collision looking for player
			continue
		if global_position.distance_squared_to(bullet.global_position) <= max_dist_sq:
			bullet.remove()
	
	if radius >= 1.5:
		remove()
