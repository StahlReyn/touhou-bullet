class_name Entity
extends Area2D

signal removed

enum CollisionMask {
	TARGET_PLAYER = 4,
	TARGET_ENEMY = 8,
}

@export var behaviors: Array[EntityBehavior]

func _ready() -> void:
	for behavior in behaviors:
		behavior.on_start(self)

func _physics_process(delta: float) -> void:
	for behavior in behaviors:
		behavior.entity_process(delta)

func add_behavior(behavior: EntityBehavior) -> void:
	behaviors.append(behavior)
	behavior.finished.connect(_on_behavior_finished)
	behavior.on_start(self)

func _on_behavior_finished(behavior: EntityBehavior) -> void:
	behaviors.erase(behavior)

func do_remove() -> void:
	removed.emit(self)
	call_deferred("queue_free")
