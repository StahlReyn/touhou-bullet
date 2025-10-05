class_name Bullet
extends Entity

@export var damage : int = 1
@export var damage_retention : float = 0.0 ## change in damage per hit. 0 is usual, 1 is damage is never lost (infinite pierce)

var do_spawn_effect : bool = true ## This will make bullet do slight fade and scale-in transition
var prev_scale : Vector2
var prev_alpha : float

const INIT_SPAWN_SCALE := 3.0
const SPAWN_SCALE_SPEED := 20.0
const SPAWN_OPACITY_SPEED := 5.0
	
func _ready() -> void:
	add_to_group("bullet")
	#prev_alpha = main_sprite.modulate.a
	#prev_scale = main_sprite.scale
	#if do_spawn_effect:
		#main_sprite.modulate.a = 0
		#main_sprite.scale = prev_scale * INIT_SPAWN_SCALE

func _physics_process(delta: float) -> void:
	#if do_spawn_effect:
		#main_sprite.modulate.a = MathUtils.lerp_smooth(main_sprite.modulate.a, prev_alpha, SPAWN_OPACITY_SPEED, delta)
		#main_sprite.scale = MathUtils.lerp_smooth(main_sprite.scale, prev_scale, SPAWN_SCALE_SPEED, delta)
	pass

func damage_target(character: Character) -> void:
	character.take_damage(damage)
	damage *= damage_retention
	if damage <= 0:
		do_remove()
	
func _on_area_entered(area: Area2D) -> void:
	if area is Character:
		damage_target(area)
		area.hit.emit()
