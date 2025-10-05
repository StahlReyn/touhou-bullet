class_name Character
extends Entity
## Parent class for Player and Enemy

signal die

@export var mhp : int = 10
@export var collision_damage : int = 10

var hp : int
var is_dead : bool = false
	
func _ready() -> void:
	super()
	reset_hp()

func reset_hp():
	hp = mhp

func set_mhp(value : int, restore : bool = true):
	mhp = value
	if restore:
		reset_hp()

func take_damage(dmg : int):
	hp -= dmg
	if hp <= 0 and not is_dead:
		kill()

func kill():
	is_dead = true
	die.emit()
	call_deferred("queue_free")

func _on_area_entered(area: Area2D) -> void:
	# Character can collide with each other. Use collision layer to differentiate.
	if area is Character:
		area.hit.emit()
		area.take_damage(collision_damage)
