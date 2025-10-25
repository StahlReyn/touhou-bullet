class_name Character
extends Entity
## Parent class for Player and Enemy

signal died
signal mhp_changed

@export var mhp : int = 10
@export var collision_damage : int = 10
@export var despawn_on_death: bool = true ## Whether to remove on death. Useful for bosses persisting when disabled
@export var damage_taken_mult: float = 1.0

var hp : int
var is_dead : bool = false
	
func _ready() -> void:
	super()
	reset_hp()

func reset_hp() -> void:
	hp = mhp

func set_mhp(value : int, restore : bool = true) -> void:
	mhp = value
	if restore:
		reset_hp()
	mhp_changed.emit()

@warning_ignore_start("narrowing_conversion")
func take_damage(dmg : int):
	hp -= dmg * damage_taken_mult
	if hp <= 0 and not is_dead:
		die()

func die() -> void:
	is_dead = true
	died.emit()
	if despawn_on_death:
		despawn()

## This is used in spellcard where boss persists
func revive() -> void:
	is_dead = false
	reset_hp()
	
func _on_area_entered(area: Area2D) -> void:
	# Character can collide with each other. Use collision layer to differentiate.
	if area is Character:
		hitted.emit()
		area.take_damage(collision_damage)
