extends Node

@onready var audio_item_get: AudioStreamPlayer = $ItemGet
@onready var audio_spellcard: AudioStreamPlayer = $Spellcard

func play_audio(sound: AudioStream, volume = 0.0) -> void:
	var node = AudioStreamPlayer.new()
	node.stream = sound
	node.volume_db = volume
	add_child(node)
	node.play()
	await node.finished
	node.call_deferred("queue_free")
	
func play_audio_2d(sound: AudioStream, pos: Vector2, volume = 0.0) -> void:
	var node = AudioStreamPlayer2D.new()
	node.position = pos
	node.stream = sound
	node.volume_db = volume
	add_child(node)
	node.play()
	await node.finished
	node.call_deferred("queue_free")

func play_item_get() -> void:
	audio_item_get.play()

func play_spell_card() -> void:
	audio_spellcard.play()
