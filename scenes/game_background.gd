class_name GameBackground
extends PanelContainer

@onready var color_overlay: ColorRect = $Overlay
@onready var stage_viewport: SubViewport = $BackgroundViewport/StageViewport

var transitioning: bool = false
var fade_speed: float = 3.0
var next_scene: PackedScene

func _ready() -> void:
	color_overlay.color.a = 0.0

func _physics_process(delta: float) -> void:
	if transitioning:
		color_overlay.color.a += fade_speed * delta
		if color_overlay.color.a >= 1.0:
			color_overlay.color.a = 1.0
			transitioning = false
			set_stage_scene(next_scene)
	else:
		if color_overlay.color.a > 0.0:
			color_overlay.color.a -= fade_speed * delta
			if color_overlay.color.a <= 0.0:
				color_overlay.color.a = 0.0
	
func transition_stage_scene(scene: PackedScene) -> void:
	next_scene = scene
	transitioning = true
	
func set_stage_scene(scene: PackedScene) -> void:
	for n in stage_viewport.get_children():
		stage_viewport.remove_child(n)
		n.queue_free() 
	stage_viewport.add_child(scene.instantiate())
