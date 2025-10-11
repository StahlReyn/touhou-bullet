class_name GameView
extends Node2D

signal start_stage

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta	

func add_bullet(bullet: Bullet) -> void:
	add_child(bullet) # May change to specific container

func add_enemy(enemy: Enemy) -> void:
	add_child(enemy)

func add_item(item: Item) -> void:
	item.collision_layer = Entity.Collision.ITEM
	item.collision_mask = Entity.Collision.PLAYER
	item.z_index = -10
	item.top_level = true
	add_child(item)
	item.add_child(ComponentDespawnEdge.create(item))

func _on_gamemain_start_stage() -> void:
	start_stage.emit()
