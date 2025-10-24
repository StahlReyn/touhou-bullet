class_name SectionScript
extends Node
## For script in making stage.
## This class also works as a facade. As the script extends this directly,
## it will be using a lot of functions contained here.

const BCOLOR_BLACK = 0
const BCOLOR_RED = 1
const BCOLOR_MAGENTA = 2
const BCOLOR_BLUE = 3
const BCOLOR_LIGHT_BLUE = 4
const BCOLOR_TEAL = 5
const BCOLOR_GREEN = 6
const BCOLOR_YELLOW = 7
const BCOLOR_ORANGE = 8
const BCOLOR_WHITE = 9

const BULLET_CIRCLE = preload("res://data/bullets/basic/circle.tscn")
const BULLET_CIRCLE_BORDERED = preload("res://data/bullets/basic/circle_bordered.tscn")
const BULLET_ARROW = preload("res://data/bullets/basic/arrow.tscn")
const BULLET_TALISMAN = preload("res://data/bullets/basic/talisman.tscn")
const BULLET_STAR = preload("res://data/bullets/basic/star.tscn")
const BULLET_OVAL = preload("res://data/bullets/basic/oval.tscn")
const BULLET_SPIKE = preload("res://data/bullets/basic/spike.tscn")
const BULLET_CRYSTAL = preload("res://data/bullets/basic/crystal.tscn")
const BULLET_BULLET = preload("res://data/bullets/basic/bullet.tscn")
const BULLET_CIRCLE_SMALL = preload("res://data/bullets/basic/circle_small.tscn")
const BULLET_CIRCLE_CHIP = preload("res://data/bullets/basic/circle_chip.tscn")
const BULLET_LASER = preload("res://data/bullets/basic/laser_partial.tscn")
const BULLET_LASER_PARTIAL = preload("res://data/bullets/basic/laser_partial.tscn")

const ENEMY_FAIRY = preload("res://data/enemies/fairy_leaf.tscn")
const ENEMY_FAIRY_SUNFLOWER = preload("res://data/enemies/fairy_sunflower.tscn")
const ENEMY_FAIRY_SUNFLOWER_DREAM = preload("res://data/enemies/fairy_sunflower_dream.tscn")

const ITEM_POWER = preload("res://data/items/item_power.tscn")
const ITEM_POINT = preload("res://data/items/item_point.tscn")

const MATERIAL_ADD: CanvasItemMaterial = preload("res://assets/resources/materials/add.tres")

var controller: StageController
var stage_data_script: StageDataScript

static func add_bullet_colored(scene: PackedScene, index: int, pos: Vector2 = Vector2.ZERO) -> Bullet:
	var bullet: Bullet = scene.instantiate()
	bullet.sprite_frame_x(index)
	GameVariables.game_area.add_bullet(bullet, pos)
	return bullet

static func add_bullet(scene: PackedScene, pos: Vector2 = Vector2.ZERO) -> Bullet:
	var bullet: Bullet = scene.instantiate()
	GameVariables.game_area.add_bullet(bullet, pos)
	return bullet

static func add_enemy(scene: PackedScene, pos: Vector2 = Vector2.ZERO) -> Enemy:
	var enemy: Enemy = scene.instantiate()
	GameVariables.game_area.add_enemy(enemy, pos)
	return enemy

static func add_item(scene: PackedScene, pos: Vector2 = Vector2.ZERO) -> Item:
	var item: Item = scene.instantiate()
	GameVariables.game_area.add_item(item, pos)
	return item

static func add_item_bulk(scene: PackedScene, count: int, pos: Vector2 = Vector2.ZERO) -> void:
	for i in range(count):
		add_item(scene, pos)

static func add_boss(scene: PackedScene, id: String, pos: Vector2 = Vector2.ZERO) -> Enemy:
	var enemy: Enemy = scene.instantiate()
	GameVariables.game_area.add_enemy_boss(enemy, id, pos)
	return enemy

## Facade for common component
static func vel(en: Entity, vel: Vector2) -> void:
	var comp := ComponentVelocity.new()
	comp.entity = en
	comp.velocity = vel
	en.add_child(comp)

static func accel(en: Entity, accel: Vector2, vel: Vector2 = Vector2.ZERO) -> void:
	var comp := ComponentAcceleration.new()
	comp.entity = en
	comp.acceleration = accel
	comp.velocity = vel
	en.add_child(comp)

static func drop(chara: Character, power: int, point: int) -> void:
	var comp := ComponentDrop.new()
	comp.entity = chara
	comp.item_drops[ComponentDrop.ItemType.POWER] = power
	comp.item_drops[ComponentDrop.ItemType.POINT] = point
	chara.died.connect(comp.drop)
	chara.add_child(comp)

static func timer_loop(en: Entity, callable: Callable, wait_time: float) -> void:
	var ti := Timer.new()
	ti.autostart = true
	ti.wait_time = wait_time
	ti.timeout.connect(callable)
	en.add_child(ti)

static func disp_rot(en: Entity) -> void:
	var comp := ComponentDisplacementRotation.new()
	comp.entity = en
	en.add_child(comp)

static func rotate_to(a: Node2D, b: Node2D) -> void:
	a.rotation = a.global_position.angle_to_point(b.global_position)

static func rotate_to_player(a: Node2D) -> void:
	if GameVariables.player == null:
		return
	a.rotation = a.global_position.angle_to_point(GameVariables.player.global_position)

static func direction_to_player(a: Node2D) -> Vector2:
	if GameVariables.player == null:
		return Vector2.ZERO
	return a.global_position.direction_to(GameVariables.player.global_position)

## Calls end chapter and spellcard without proceeding to next section immediately
func end_chapter() -> void:
	controller.spellcard_displayer.end_spellcard()
	controller.end_chapter()
	call_deferred("remove_enemy_entities")

func end_script() -> void:
	stage_data_script.run_next_script()
	call_deferred("queue_free")

## This skips the entire section. Not for usual gameplay.
func end_section() -> void:
	controller.end_section()
	call_deferred("queue_free")

func start_spellcard(time: float) -> void:
	controller.start_spellcard(time)
	controller.spellcard_displayer.timeout.connect(_on_spellcard_timeout)

func start_nonspellcard(time: float) -> void:
	controller.start_nonspellcard(time)
	controller.spellcard_displayer.timeout.connect(_on_spellcard_timeout)

## Runs on spellcard finishing. Ends the section by default
func _on_spellcard_timeout() -> void:
	end_script()

func remove_enemy_entities() -> void:
	controller.game_area.remove_clearable_bullets()
	controller.game_area.remove_non_boss_enemies()

func get_boss(id: String, fallback_scene: PackedScene, fallback_pos: Vector2 = Vector2.ZERO) -> Enemy:
	if GameVariables.boss_list.has(id):
		return GameVariables.boss_list[id]
	return add_boss(fallback_scene, id, fallback_pos)

func transition_stage_scene(scene: PackedScene) -> void:
	controller.transition_stage_scene(scene)
