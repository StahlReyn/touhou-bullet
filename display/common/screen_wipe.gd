class_name ScreenWipe
extends ColorRect

signal opened
signal closed

enum Status {
	IDLE,
	CLOSING,
	OPENING
}

var status: Status = Status.OPENING
var progress: float = 1.0
var next_scene_path: String

func _ready() -> void:
	material.set_shader_parameter("percentage", progress)

func _physics_process(delta: float) -> void:
	progress = clamp(progress, 0, 1)	
	material.set_shader_parameter("percentage", progress)
	
	if status == Status.CLOSING:
		progress += delta * 10
		if progress >= 1:
			closed.emit()
			status = Status.IDLE
			if next_scene_path.length() > 0:
				SceneManager.goto_scene(next_scene_path)
	elif status == Status.OPENING:
		progress -= delta * 10
		if progress <= 0:
			opened.emit()
			status = Status.IDLE

func close() -> void:
	status = Status.CLOSING

func transition_scene(next_scene_path: String) -> void:
	status = Status.CLOSING
	self.next_scene_path = next_scene_path
