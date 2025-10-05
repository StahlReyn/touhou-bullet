extends Node

func lerp_smooth(a, b, decay, dt):
	return lerp(a, b, 1 - exp(-decay * dt))

func lerp_angle_smooth(a, b, decay, dt):
	return lerp_angle(a, b, 1 - exp(-decay * dt))

func randv2_angle() -> Vector2:
	return Vector2.from_angle(randf() * TAU)

func randv2_range(minv: Vector2, maxv: Vector2) -> Vector2:
	return Vector2(randf_range(minv.x, maxv.x), randf_range(minv.y, maxv.y))

func randv2_rangef(minx: float, miny: float, maxx: float, maxy: float) -> Vector2:
	return Vector2(randf_range(minx, maxx), randf_range(miny, maxy))

func rotate_around_point(point: Vector2, center: Vector2, angle : float) -> Vector2:
	return (point - center).rotated(angle) + center
