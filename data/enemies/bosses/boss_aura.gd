extends Node2D

enum Status {
	HIDE,
	START,
	SHOW,
	END
}

@onready var viewport_size: Vector2 = get_viewport().size
@onready var distort := $BackBufferCopy/Distort
@onready var circle := $Circle

@onready var distort_shader: ShaderMaterial = distort.material
@onready var circle_shader: ShaderMaterial = circle.material

@onready var main_radius: float = distort_shader.get_shader_parameter("radius")
@onready var main_alpha: float = circle_shader.get_shader_parameter("alpha")

var alpha: float = 0.0
var radius: float = 0.0
var x_rot: float = 0.0
var y_rot: float = 0.0
var time: float = 0.0

var status: Status = Status.HIDE

func _ready() -> void:
	start()

func _physics_process(delta: float) -> void:
	match status:
		Status.START:
			alpha += delta
			radius = min(radius + delta, main_radius)
			if alpha >= main_alpha:
				alpha = main_alpha
				status = Status.SHOW
		Status.END:
			alpha -= delta
			radius = max(radius - delta, 0.0)
			if alpha <= 0.0:
				alpha = 0.0
				status = Status.HIDE
			
	rotation = time * -0.7
	x_rot = sin(time * 0.1) * 5
	y_rot = cos(time * 0.2) * 40
	
	circle_shader.set_shader_parameter("x_rot", x_rot)
	circle_shader.set_shader_parameter("y_rot", y_rot)
	circle_shader.set_shader_parameter("alpha", alpha)
	
	distort_shader.set_shader_parameter("center", global_position / viewport_size)
	distort_shader.set_shader_parameter("radius", radius)
	
	time += delta

func start() -> void:
	status = Status.START
	circle_shader.set_shader_parameter("alpha", alpha)
	distort_shader.set_shader_parameter("center", global_position / viewport_size)
	distort_shader.set_shader_parameter("radius", radius)
