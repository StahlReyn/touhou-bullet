## For script in making stage.
class_name SectionScript
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
	FAIRY,
	FAIRY_SUNFLOWER
}

## List of Common Enemy scenes assigned to a bullet type
const ENEMY_SCENES: Dictionary[EnemyType, PackedScene] = {
	EnemyType.FAIRY: preload("res://data/enemies/fairy_leaf.tscn"),
	EnemyType.FAIRY_SUNFLOWER: preload("res://data/enemies/fairy_sunflower.tscn")
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

var controller: StageController

## Only gets the bullet but does not add it. Useful for factories
static func get_bullet(
	type: BulletType,
	color: BulletColor = BulletColor.WHITE
) -> Bullet:
	var bullet: Bullet = BULLET_SCENES[type].instantiate()
	bullet.offset_sprite_frame(color)
	return bullet

static func get_enemy(type: EnemyType) -> Enemy:
	var enemy: Enemy = ENEMY_SCENES[type].instantiate()
	return enemy

static func get_item(type: ItemType) -> Item:
	var item: Item = ITEM_SCENES[type].instantiate()
	return item

static func add_bullet(
	type: BulletType, 
	color: BulletColor = BulletColor.WHITE, 
	pos: Vector2 = Vector2.ZERO
) -> Bullet:
	var bullet: Bullet = get_bullet(type, color)
	GameVariables.game_area.add_bullet(bullet, pos)
	return bullet

static func add_enemy(type: EnemyType, pos: Vector2 = Vector2.ZERO) -> Enemy:
	var enemy: Enemy = get_enemy(type)
	GameVariables.game_area.add_enemy(enemy, pos)
	return enemy

static func add_item(type: ItemType, pos: Vector2 = Vector2.ZERO) -> Item:
	var item: Item = get_item(type)
	GameVariables.game_area.add_item(item, pos)
	return item

func end_section() -> void:
	controller.end_chapter()
	controller.end_section()
	call_deferred("despawn_all")
	call_deferred("queue_free")

func start_spellcard() -> void:
	controller.start_spellcard()

func despawn_all() -> void:
	controller.game_area.despawn_enemy_bullets()
	controller.game_area.despawn_enemies()
