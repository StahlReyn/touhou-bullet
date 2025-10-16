class_name SpellCardDisplayer
extends PanelContainer

enum State {
	SPELL, ## Spellcard with name and effects
	NON_SPELL, ## Boss non spells, still show timer and name
	REGULAR, ## Regular stage
}

@onready var animation_node: AnimationPlayer = $AnimationPlayer
@onready var label_name: Label = $SpellCardName/LabelName
@onready var label_timer: Label = $MarginContainer/LabelTimer
@onready var margin_timer: MarginContainer = $MarginContainer

static var margin_active: int = 48
static var margin_inactive: int = 10
static var lerp_speed: float = 4.0

var cur_state : int

func _ready() -> void:
	set_state(State.REGULAR)
	call_deferred("setup_nodes")

func _physics_process(delta: float) -> void:
	process_timer_display(delta)

func setup_nodes() -> void:
	label_timer.set_modulate(Color(1,1,1,0))
	reset_anim()

func process_timer_display(delta: float) -> void:
	var margin = margin_inactive
	var alpha = 0.0
	
	match cur_state:
		State.SPELL:
			alpha = 1.0
			margin = margin_active
	
	margin_timer.modulate.a = MathUtils.lerp_smooth(
		margin_timer.modulate.a, alpha, lerp_speed, delta
	)
	margin_timer.add_theme_constant_override(
		"margin_top",
		MathUtils.lerp_smooth(
			get_theme_constant("margin_top"), 
			margin, lerp_speed, delta
		)
	)

func reset_anim() -> void:
	animation_node.play(&"RESET")
	animation_node.advance(0)

func start_spellcard() -> void:
	reset_anim()
	set_state(State.SPELL)
	animation_node.play("start")
	AudioManager.play_spell_card()

func end_spellcard() -> void:
	set_state(State.REGULAR)
	animation_node.play("end")

func start_non_spell() -> void:
	pass

func end_non_spell() -> void:
	pass

func set_state(id : int) -> void:
	cur_state = id
