extends ComponentPlayerShooter

const WOUND_SCENE := preload("res://data/bullets/player/junko_wound_bullet.tscn")

@onready var target_node: Node2D = $".."

var target_enemy: Entity

var rotation: float = 0.0
var amount: int = 16
var speed: float = 300
var acceleration: float = -300
var target_time: float = 0.0

func _physics_process(delta: float) -> void:
	super(delta)
	if not is_instance_valid(target_enemy):
		target_enemy = null
	if target_enemy == null or target_time > 0.5:
		target_enemy = get_closest_target()
		target_time = 0.0
	if target_enemy != null:
		target_node.global_position = MathUtils.lerp_smooth(
			target_node.global_position, target_enemy.global_position, 10.0, delta
		)
	
	target_node.rotation += delta
	target_time += delta
		
func process_shoot_unfocused() -> void:
	shoot_circle_set(amount, 0.75, SectionScript.BCOLOR_BLUE)
	shoot_circle_set(amount, 1, SectionScript.BCOLOR_RED)

func process_shoot_focused() -> void:
	return

func shoot_circle_set(circ_amount: int, mult: float, color: int) -> void:
	for i in range(circ_amount):
		var bullet: JunkoWoundBullet = WOUND_SCENE.instantiate()
		var direction := Vector2.from_angle(i * TAU/circ_amount + rotation)
		bullet.sprite_frame_x(color)
		
		bullet.monitoring = false
		GameVariables.game_area.add_bullet_player(bullet, target_node.global_position)
		bullet.position += direction * 100
		bullet.comp_accel.acceleration = direction * acceleration * mult
		bullet.comp_accel.velocity = direction * speed
		bullet.target_entity = target_node
		bullet.timer.start(speed / (acceleration * mult))
		bullet.monitoring = true

func get_closest_target() -> Entity:
	var entity_list := GameUtils.get_enemy_list()
	if entity_list.size() <= 0:
		return entity # Return self
	var closest_entity: Entity = entity_list[0]
	var closest_dist: float = 1000000.0
	var new_dist: float
	for en: Entity in GameUtils.get_enemy_list():
		new_dist = en.global_position.distance_squared_to(entity.global_position)
		if new_dist < closest_dist:
			closest_dist = new_dist
			closest_entity = en
	return closest_entity
	
