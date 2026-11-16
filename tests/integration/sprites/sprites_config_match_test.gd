extends RefCounted
## Integration: every sprite in game_config.json "sprites" exists as a strip whose
## width splits into the configured frame count, and has its generator source.

const CONFIG_PATH := "res://assets/data/game_config.json"
const STRIP := "res://assets/sprites/custom/%s/%s_strip.png"
const GEN := "res://assets/source/sprites/%s/gen.py"

var failures: Array[String] = []


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures.append(msg)


func _sprites() -> Dictionary:
	var cfg: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	var s: Variant = cfg.get("sprites", {}) if cfg is Dictionary else {}
	return s if s is Dictionary else {}


func test_sprite_config_lists_the_four_sprites() -> void:
	var s := _sprites()
	for name: String in ["firefly", "mote", "raindrop", "splash"]:
		_check(s.has(name), "sprites.%s missing from config" % name)
	_check(int(s.get("scale", 0)) >= 1, "sprites.scale must be a whole number >= 1")


func test_each_strip_splits_into_its_frames() -> void:
	var s := _sprites()
	for name: String in s:
		if not s[name] is Dictionary:
			continue
		var path := STRIP % [name, name]
		_check(ResourceLoader.exists(path), "%s missing (gamekit art run dom-dom-dem-mua %s)" % [path, name])
		if not ResourceLoader.exists(path):
			continue
		var tex: Texture2D = load(path)
		var frames := int(s[name].get("frames", 1))
		_check(frames >= 1 and tex.get_width() % frames == 0,
			"%s: width %d does not split into %d frames" % [name, tex.get_width(), frames])
		_check(float(s[name].get("fps", 0)) > 0.0, "%s: fps must be > 0" % name)
		var a: Variant = s[name].get("anchor")
		_check(a is Array and a.size() == 2, "%s: anchor [x, y] missing" % name)
		if a is Array and a.size() == 2:
			var fw := float(tex.get_width()) / maxf(1.0, float(frames))
			_check(float(a[0]) >= 0.0 and float(a[0]) <= fw and float(a[1]) >= 0.0
				and float(a[1]) <= float(tex.get_height()),
				"%s: anchor %s outside the %dx%d frame" % [name, a, int(fw), tex.get_height()])


func test_each_sprite_has_its_generator() -> void:
	# assets/source is .gdignore'd, so check the file on disk, not as a resource.
	for name: String in _sprites():
		if _sprites()[name] is Dictionary:
			var gen := ProjectSettings.globalize_path(GEN % name)
			_check(FileAccess.file_exists(gen), "%s missing: sprite cannot be regenerated" % gen)
