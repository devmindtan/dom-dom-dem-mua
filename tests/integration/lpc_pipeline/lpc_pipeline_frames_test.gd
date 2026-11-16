extends RefCounted
## Integration: every ingested character has a SpriteFrames with the core
## animations and credits beside it. Skips (passes) when none are ingested.

const CHARACTERS_DIR := "res://assets/sprites/characters"

var failures: Array[String] = []


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures.append(msg)


func _characters() -> PackedStringArray:
	var dir := DirAccess.open(CHARACTERS_DIR)
	return dir.get_directories() if dir else PackedStringArray()


func test_each_character_has_frames_with_walk_in_four_directions() -> void:
	for n in _characters():
		var path := CHARACTERS_DIR.path_join("%s/%s_frames.tres" % [n, n])
		_check(ResourceLoader.exists(path), "%s: missing %s (run gamekit sprites)" % [n, path])
		if not ResourceLoader.exists(path):
			continue
		var frames: SpriteFrames = load(path)
		for f: String in ["up", "left", "down", "right"]:
			var a := "walk_" + f
			_check(frames.has_animation(a) and frames.get_frame_count(a) == 8,
				"%s: %s should have 8 frames" % [n, a])


func test_each_character_ships_credits() -> void:
	for n in _characters():
		var csv := CHARACTERS_DIR.path_join("%s/credits.csv" % n)
		_check(FileAccess.file_exists(csv) and FileAccess.get_file_as_string(csv).split("\n").size() > 2,
			"%s: credits.csv missing or empty" % n)
	if not _characters().is_empty():
		_check(FileAccess.file_exists("res://assets/credits/CREDITS.md"), "assets/credits/CREDITS.md missing")
