class_name Character
extends Entity
## Parent class for Player and Enemy

signal died
signal mhp_changed

@export var mhp: float = 10
@export var collision_damage: float = 10
@export var free_on_death: bool = true ## Whether to remove on death. Useful for bosses persisting when disabled
@export var damage_taken_mult: float = 1.0

var hp: float
var is_dead: bool = false
	
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

func take_damage(dmg: int):
	if damage_taken_mult <= 0:
		AudioManager.play_block()
		return
	var final_dmg = dmg * damage_taken_mult
	hp -= final_dmg
	if hp <= 0 and not is_dead:
		die()

func die() -> void:
	is_dead = true
	died.emit()
	if free_on_death:
		freed.emit()
		call_deferred("queue_free")

## This is used in spellcard where boss persists
func revive() -> void:
	is_dead = false
	reset_hp()
	
func _on_area_entered(area: Area2D) -> void:
	# Character can collide with each other. Use collision layer to differentiate.
	if area is Character:
		hitted.emit()
		area.take_damage(collision_damage)
