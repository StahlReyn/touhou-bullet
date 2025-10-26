class_name DialogueSpawnBoss
extends DialogueEvent

@export_group("Instantiation")
@export var id: String
@export var enemy_scene: PackedScene
@export_group("Animation")
@export var start_position: Vector2 = Vector2(-50, -50)
@export var target_position: Vector2 = Vector2(384, 250)
@export var duration: float = 1.0
@export var trans: Tween.TransitionType = Tween.TRANS_QUAD

func run() -> void:
	var enemy: Enemy = SectionScript.get_boss(id, enemy_scene, start_position)
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "position", target_position, 1.0).set_trans(trans)
	enemy.hp = 0
	enemy.damage_taken_mult = 0.0
	
	if wait_for_input:
		await tween.finished
	
	finished.emit()
