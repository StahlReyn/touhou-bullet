extends Node

func lerp_smooth(a, b, decay, dt):
	return lerp(a, b, 1 - exp(-decay * dt))

func lerp_angle_smooth(a, b, decay, dt):
	return lerp_angle(a, b, 1 - exp(-decay * dt))

func get_random_direction_vector() -> Vector2:
	return Vector2.from_angle(randf() * TAU)

func rotate_around_point(point: Vector2, center: Vector2, angle : float) -> Vector2:
	return (point - center).rotated(angle) + center
