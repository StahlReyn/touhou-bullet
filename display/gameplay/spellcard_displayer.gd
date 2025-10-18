class_name SpellcardDisplayer
extends PanelContainer

signal timeout

enum Status {
	SPELL, ## Spellcard with name and effects
	NON_SPELL, ## Boss non spells, still show timer and name
	REGULAR, ## Regular stage
}

@onready var animation_node: AnimationPlayer = $AnimationPlayer
@onready var label_name: Label = $SpellCardName/LabelName
@onready var label_timer: Label = $TimerContainer/LabelTimer
@onready var top_control = $TimerContainer/Top

static var lerp_speed: float = 2.0

var countdown: float = 0.0
var status: int

func _ready() -> void:
	status = Status.REGULAR
	label_timer.modulate.a = 0.0
	reset_anim()

func _physics_process(delta: float) -> void:
	if countdown > 0:
		countdown -= delta
		if countdown <= 0:
			countdown = 0.0
			timeout.emit()
			
	process_timer_display(delta)

func process_timer_display(delta: float) -> void:
	var ratio = 0.0
	var alpha = 0.0
	
	if status != Status.REGULAR:
		alpha = 1.0
	if status == Status.SPELL:
		ratio = 0.1
	
	label_timer.modulate.a = MathUtils.lerp_smooth(
		label_timer.modulate.a, alpha, lerp_speed, delta
	)
	
	top_control.size_flags_stretch_ratio = MathUtils.lerp_smooth(
		top_control.size_flags_stretch_ratio, ratio, lerp_speed, delta
	)
	
	label_timer.text = "%.2f" % countdown

func reset_anim() -> void:
	animation_node.play(&"RESET")
	animation_node.advance(0)

func start_spellcard(time: float) -> void:
	countdown = time
	status = Status.SPELL
	reset_anim()
	animation_node.play("start")
	AudioManager.play_spellcard()
	label_name.text = GameVariables.cur_spellcard_name

func start_nonspellcard(time: float) -> void:
	countdown = time
	status = Status.NON_SPELL
	reset_anim()

func end_spellcard() -> void:
	if status == Status.SPELL:
		animation_node.play("end")
	status = Status.REGULAR

func start_non_spell() -> void:
	pass

func end_non_spell() -> void:
	pass
