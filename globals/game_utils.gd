extends Node

var game_area: Vector2 = Vector2(768,896) # Half is Vector2(384,448)
var default_time_scale := 1.0

func freeze_frame(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = default_time_scale

func get_enemy_list() -> Array[Node]:
	return get_tree().get_nodes_in_group("enemy")

func get_enemy_boss_list() -> Array[Node]:
	return get_tree().get_nodes_in_group("enemy_boss")

func get_bullet_list() -> Array[Node]:
	return get_tree().get_nodes_in_group("bullet")
	
func get_bullet_count() -> int:
	return get_tree().get_nodes_in_group("bullet").size()

func get_item_count() -> int:
	return get_tree().get_nodes_in_group("item").size()

func get_enemy_count() -> int:
	return get_tree().get_nodes_in_group("enemy").size()

func get_point_items() -> Array[Node]:
	return get_tree().get_nodes_in_group("item")
