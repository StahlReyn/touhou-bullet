@abstract
class_name PatternFactory
extends Node

var spawned_bullets: Array[Bullet]

## Creates a Bullet
@abstract func create() -> Array[Bullet]
