class_name SpriteEnemySimple
extends Sprite2D
## Groups of sprite, for enemies with variants like fairies

@export var col_anims: Dictionary = {
	"default": 0,
	"diagonal": 1,
	"side": 2,
}

@export var row_variants: Dictionary = {
	"blue": 0,
	"red": 1,
	"green": 2,
	"yellow": 3,
}

@export var frame_delay: float = 0.0833333
@export var frames_per_anim: int = 3

var cur_anim: int = 0
var cur_frame: int = 0
var cur_row: int = 0
var frame_timer: float = 0.0
var last_pos: Vector2

func _ready() -> void:
	last_pos = global_position

func _physics_process(delta: float) -> void:
	frame_timer -= delta
	if frame_timer <= 0:
		update_animation() 
		update_frame()
		frame_timer += frame_delay

func update_frame() -> void:
	cur_frame += 1
	cur_frame = cur_frame % frames_per_anim
	# Cur frame + Column set (frame in an anim) + Row frames (Enemy type)
	var frame_offset = (cur_anim * frames_per_anim) + (cur_row * hframes)
	set_frame(cur_frame + frame_offset)

func set_type(key: String = "blue") -> void:
	cur_row = row_variants[key]

func set_anim(key: String = "default") -> void:
	cur_anim = col_anims[key]

func update_animation() -> void:
	var diff_pos = global_position - last_pos
	# Using relative size of axis, faster than atan()
	if abs(diff_pos.x) * 0.5 > abs(diff_pos.y):
		set_anim("side")
	elif abs(diff_pos.x) * 3.0 > abs(diff_pos.y):
		set_anim("diagonal")
	else:
		set_anim("default")
	flip_h = diff_pos.x < 0
	last_pos = global_position # Update pos
