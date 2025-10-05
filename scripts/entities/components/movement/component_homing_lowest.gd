class_name ComponentHomingLowest
extends EntityComponent

@export var move_speed : float = 1000.0
@export var rotation_speed : float = 10.0

var cur_target_enemy: Enemy

static func rand_dir(entity_owner: Entity, magnitude: float) -> ComponentHomingLowest:
	var comp := new()
	comp.velocity = MathUtils.randv2_angle() * magnitude
	comp.entity = entity_owner
	return comp

func _ready() -> void:
	cur_target_enemy = get_enemy_target()

func _physics_process(delta: float) -> void:
	if cur_target_enemy == null: # try get new one if old is gone
		cur_target_enemy = get_enemy_target()
	
	if cur_target_enemy != null: # turn toward if exists
		var target_angle = entity.global_position.angle_to_point(cur_target_enemy.global_position)
		entity.rotation = MathUtils.lerp_angle_smooth(entity.rotation, target_angle, rotation_speed, delta)
	
	# move based on rotation
	entity.position += Vector2.from_angle(entity.rotation) * move_speed * delta

func physics_process_active(delta: float) -> void:
	pass

func get_enemy_target() -> Enemy:
	var enemy_list = GameUtils.get_enemy_list()
	var cur_enemy = null
	for enemy in enemy_list:
		if enemy is Enemy:
			if cur_enemy == null:
				cur_enemy = enemy
			# Get enemy with largest y, Lowest
			elif enemy.position.y > cur_enemy.position.y: 
				cur_enemy = enemy
	return cur_enemy
