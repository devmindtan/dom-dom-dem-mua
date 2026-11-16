extends RefCounted
## Integration: every sprite main.gd draws has a strip, a <name>.json written by its
## gen.py (frames, frame_size, fps, anchor) that matches the strip, and its generator.
## Lesson 2026-11-16 (LESSONS.md): sprites must be placed by an anchor, never by the
## canvas centre, and the frame data must come from the generator, not be typed by hand.

const MainScript := preload("res://src/game/main.gd")
const CONFIG_PATH := "res://assets/data/game_config.json"
const DIR := "res://assets/sprites/custom/%s/%s"
const GEN := "res://assets/source/sprites/%s/gen.py"

var failures: Array[String] = []


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures.append(msg)


func _meta(name: String) -> Dictionary:
	var path := DIR % [name, name + ".json"]
	if not FileAccess.file_exists(path):
		return {}
	var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return v if v is Dictionary else {}


func test_config_scale_is_a_whole_number() -> void:
	var cfg: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	var s: Variant = cfg.get("sprites", {}) if cfg is Dictionary else {}
	_check(s is Dictionary and int(s.get("scale", 0)) >= 1, "sprites.scale must be a whole number >= 1")


func test_each_sprite_meta_matches_its_strip() -> void:
	for name: String in MainScript.SPRITES:
		var strip := DIR % [name, name + "_strip.png"]
		var m := _meta(name)
		_check(ResourceLoader.exists(strip), "%s missing (gamekit art run dom-dom-dem-mua %s)" % [strip, name])
		_check(not m.is_empty(), "%s.json missing: gen.py must call write_meta()" % name)
		if m.is_empty() or not ResourceLoader.exists(strip):
			continue
		var tex: Texture2D = load(strip)
		var n := int(m.get("frames", 0))
		var fs: Array = m.get("frame_size", [0, 0])
		_check(n >= 1 and tex.get_width() == int(fs[0]) * n and tex.get_height() == int(fs[1]),
			"%s: strip %dx%d does not match %d x %s" % [name, tex.get_width(), tex.get_height(), n, fs])
		_check(float(m.get("fps", 0)) > 0.0, "%s: fps must be > 0" % name)


func test_each_anchor_lies_inside_its_frame() -> void:
	for name: String in MainScript.SPRITES:
		var m := _meta(name)
		var a: Variant = m.get("anchor")
		var fs: Array = m.get("frame_size", [0, 0])
		_check(a is Array and a.size() == 2, "%s: anchor [x, y] missing" % name)
		if a is Array and a.size() == 2:
			_check(float(a[0]) >= 0.0 and float(a[0]) <= float(fs[0])
				and float(a[1]) >= 0.0 and float(a[1]) <= float(fs[1]),
				"%s: anchor %s outside the %s frame" % [name, a, fs])


func test_each_sprite_has_its_generator() -> void:
	# assets/source is .gdignore'd, so check the file on disk, not as a resource.
	for name: String in MainScript.SPRITES:
		var gen := ProjectSettings.globalize_path(GEN % name)
		_check(FileAccess.file_exists(gen), "%s missing: sprite cannot be regenerated" % gen)


func test_sheet_animations_are_contiguous() -> void:
	# A sheet with several animations lists them in <name>.json; every frame must
	# belong to exactly one animation, starting at 0, with its own fps and loop.
	for name: String in MainScript.SPRITES:
		var m := _meta(name)
		var anims: Variant = m.get("animations")
		if anims == null:
			continue
		_check(anims is Array and not (anims as Array).is_empty(),
			"%s: animations must be a non-empty array" % name)
		if not (anims is Array):
			continue
		var next := 0
		var seen := {}
		for a: Variant in anims:
			_check(a is Dictionary, "%s: animation entry is not an object" % name)
			if not (a is Dictionary):
				continue
			var an := str(a.get("name", ""))
			_check(an != "" and not seen.has(an), "%s: animation name %r missing or repeated" % [name, an])
			seen[an] = true
			_check(int(a.get("start", -1)) == next,
				"%s/%s starts at %s, expected %d" % [name, an, a.get("start"), next])
			var n := int(a.get("frames", 0))
			_check(n >= 1, "%s/%s: frames must be >= 1" % [name, an])
			_check(float(a.get("fps", 0)) > 0.0, "%s/%s: fps must be > 0" % [name, an])
			next += n
		_check(next == int(m.get("frames", -1)),
			"%s: animations use %d frames, sheet has %s" % [name, next, m.get("frames")])
