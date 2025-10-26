class_name Bullet
extends Entity

@export var damage: int = 10
@export var damage_retention: float = 0.0 ## change in damage per hit. 0 is usual, 1 is damage is never lost (infinite pierce)
@export var main_sprite: Sprite2D

var do_spawn_effect: bool = true ## This will make bullet do slight fade and scale-in transition
var main_scale: Vector2
var main_alpha: float
var fading_in: bool = false

const INIT_SPAWN_SCALE := 3.0
const SPAWN_SCALE_SPEED := 10.0
const SPAWN_OPACITY_SPEED := 10.0
	
func _ready() -> void:
	super()
	add_to_group("bullet")
	if main_sprite != null and do_spawn_effect:
		fading_in = true
		main_alpha = main_sprite.modulate.a
		main_scale = main_sprite.scale
		main_sprite.modulate.a = 0
		main_sprite.scale = main_scale * INIT_SPAWN_SCALE

func _physics_process(delta: float) -> void:
	if fading_in:
		main_sprite.modulate.a = MathUtils.lerp_smooth(main_sprite.modulate.a, main_alpha, SPAWN_OPACITY_SPEED, delta)
		main_sprite.scale = MathUtils.lerp_smooth(main_sprite.scale, main_scale, SPAWN_SCALE_SPEED, delta)
		if main_sprite.scale == main_scale and main_sprite.modulate.a == main_alpha:
			fading_in = false

func sprite_frame_x(index: int):
	main_sprite.frame_coords.x = index

@warning_ignore_start("narrowing_conversion")
func damage_target(character: Character) -> void:
	character.take_damage(damage)
	GameVariables.add_score(damage * 100)
	damage *= damage_retention
	if damage <= 0:
		despawn()
	
func _on_area_entered(area: Area2D) -> void:
	if area is Character:
		damage_target(area)
		hitted.emit()
		AudioManager.play_hit()
	if area is Graze:
		area.add_graze()
