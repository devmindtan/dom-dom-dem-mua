class_name GameConfig
extends RefCounted
## Loads the data-driven tuning values from a JSON file.


## Returns the parsed config, or an empty Dictionary (with an error logged)
## when the file is missing or is not a JSON object.
static func load_config(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Config not found: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Dictionary:
		return parsed
	push_error("Config is not a JSON object: %s" % path)
	return {}
