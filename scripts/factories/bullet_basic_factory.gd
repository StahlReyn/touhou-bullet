class_name BulletBasicFactory
extends BulletFactory

enum BulletColor {
	BLACK,
	RED,
	MAGENTA,
	BLUE,
	LIGHT_BLUE,
	TEAL,
	GREEN,
	YELLOW,
	ORANGE,
	WHITE
}

enum BulletType {
	CIRCLE,
	CIRCLE_BORDERED,
	ARROW,
	TALISMAN,
	STAR,
	OVAL,
	SPIKE,
	CRYSTAL,
	BULLET,
	CIRCLE_SMALL,
	CIRCLE_CHIP,
	LASER,
	LASER_PARTIAL
}

## List of bullet scenes assigned to a bullet type
const SCENES: Dictionary[BulletType, PackedScene]= {
	BulletType.CIRCLE: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.CIRCLE_BORDERED: preload("res://data/bullets/basic/circle_bordered.tscn"),
	BulletType.ARROW: preload("res://data/bullets/basic/arrow.tscn"),
	BulletType.TALISMAN: preload("res://data/bullets/basic/talisman.tscn"),
	BulletType.STAR: preload("res://data/bullets/basic/star.tscn"),
	BulletType.OVAL: preload("res://data/bullets/basic/oval.tscn"),
	BulletType.SPIKE: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.CRYSTAL: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.BULLET: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.CIRCLE_SMALL: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.CIRCLE_CHIP: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.LASER: preload("res://data/bullets/basic/circle.tscn"),
	BulletType.LASER_PARTIAL: preload("res://data/bullets/basic/circle.tscn")
}

@export var bullet_type: BulletType = BulletType.CIRCLE
@export var bullet_color: BulletColor = BulletColor.BLACK

func create() -> Bullet:
	var bullet: Bullet = SCENES[bullet_type].instantiate()
	return bullet
