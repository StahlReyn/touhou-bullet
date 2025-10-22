class_name GameBackground
extends PanelContainer

@onready var stage_viewport: SubViewport = $BackgroundViewport/StageViewport
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var fade_curve: Curve

var next_scene: PackedScene

var progress: float = 0.0

func _ready() -> void:
	animation.play("RESET")
	pass

func _physics_process(delta: float) -> void:
	pass
	
func transition_stage_scene(scene: PackedScene) -> void:
	next_scene = scene
	animation.play("transition")
	
func set_stage_scene(scene: PackedScene) -> void:
	for n in stage_viewport.get_children():
		stage_viewport.remove_child(n)
		n.queue_free() 
	stage_viewport.add_child(scene.instantiate())

func set_next_scene() -> void:
	set_stage_scene(next_scene)
