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

# Number Displays
func two_decimal_int(number: int) -> String:
	return "%.2f" % (float(number) / 100)

func percentage_display(number: float) -> String:
	return "%.1f" % (float(number) * 100) + "%"
	
func thousands_sep(number, prefix = '') -> String:
	number = int(number)
	var neg = false
	if number < 0:
		number = -number
		neg = true
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	if neg: res = '-'+prefix+res
	else: res = prefix+res
	return res
