extends RefCounted
## Unit tests for LpcCharacter's pure helpers (run by tests/run_tests.gd).

const LpcCharacterScript := preload("res://addons/gamekit/lpc/lpc_character.gd")

var failures: Array[String] = []


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures.append(msg)


func test_facing_from_vector_cardinals_map_to_directions() -> void:
	_check(LpcCharacterScript.facing_from_vector(Vector2.RIGHT) == &"right", "right")
	_check(LpcCharacterScript.facing_from_vector(Vector2.LEFT) == &"left", "left")
	_check(LpcCharacterScript.facing_from_vector(Vector2.UP) == &"up", "up")
	_check(LpcCharacterScript.facing_from_vector(Vector2.DOWN) == &"down", "down")


func test_facing_from_vector_diagonal_prefers_vertical() -> void:
	_check(LpcCharacterScript.facing_from_vector(Vector2(1, 1)) == &"down", "exact diagonal -> down")
	_check(LpcCharacterScript.facing_from_vector(Vector2(1, 0.5)) == &"right", "mostly right -> right")


func test_facing_from_vector_zero_keeps_fallback() -> void:
	_check(LpcCharacterScript.facing_from_vector(Vector2.ZERO, &"left") == &"left", "zero keeps fallback")


func test_animation_name_joins_action_and_facing() -> void:
	_check(LpcCharacterScript.animation_name(&"walk", &"left") == &"walk_left", "walk_left")


func test_play_action_without_frames_returns_false() -> void:
	var c: LpcCharacter = LpcCharacterScript.new()
	_check(not c.play_action(&"walk"), "no sprite_frames -> false")
	c.free()
