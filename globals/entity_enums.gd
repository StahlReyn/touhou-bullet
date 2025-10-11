## This class contain many common entities assigned to an enum
## for easy export variable purposes. Specialized entities
## does not neccessarily need one
extends Node

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

## List of Common Bullet scenes assigned to a bullet type
const BULLET_SCENES: Dictionary[BulletType, PackedScene] = {
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

enum EnemyType {
	FAIRY	
}

## List of Common Enemy scenes assigned to a bullet type
const ENEMY_SCENES: Dictionary[EnemyType, PackedScene] = {
	EnemyType.FAIRY: preload("res://data/enemies/fairy_leaf.tscn")
}

enum ItemType {
	POWER,
	POINT
}

## List of Common Item scenes assigned to a bullet type
const ITEM_SCENES: Dictionary[ItemType, PackedScene] = {
	ItemType.POWER: preload("res://data/items/item_power.tscn"),
	ItemType.POINT: preload("res://data/items/item_point.tscn")
}

func get_bullet(type: BulletType) -> Bullet:
	return BULLET_SCENES[type].instantiate() as Bullet

func get_enemy(type: EnemyType) -> Enemy:
	return ENEMY_SCENES[type].instantiate() as Enemy

func get_item(type: ItemType) -> Item:
	return ITEM_SCENES[type].instantiate() as Item
