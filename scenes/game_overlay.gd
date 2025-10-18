class_name GameOverlay
extends Node2D

@onready var noise = FastNoiseLite.new()

@onready var chapter_popup: ChapterPopup = $ChapterPopup
@onready var spellcard_displayer: SpellcardDisplayer = $SpellcardDisplayer

var cur_shake_strength: float = 0
var noise_i: float = 0.0

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	process_shake(delta)

func process_shake(delta: float) -> void:
	cur_shake_strength = max(0, cur_shake_strength - delta * 150)
	noise_i += delta * 1000
	
	position.x = noise.get_noise_2d(0, noise_i) * cur_shake_strength
	position.y = noise.get_noise_2d(0, -noise_i) * cur_shake_strength

func shake(amount: float) -> void:
	cur_shake_strength = amount

func display_chapter() -> void:
	display_chapter()
