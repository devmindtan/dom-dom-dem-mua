class_name LightMeter
extends RefCounted
## The firefly's light, which is also its life.
##
## Pure logic with no scene dependencies so it can be unit-tested headless.
## All values come from the "light" block of game_config.json.

## Upper bound of light.
var max_light: float
## Current light, always within [0, max_light].
var light: float
## Light lost per second while the run is active.
var drain_per_sec: float
## Light gained when a mote is collected.
var mote_gain: float
## Light lost when a raindrop hits the firefly.
var hit_loss: float


func _init(p_max: float, p_start: float, p_drain: float, p_gain: float, p_hit: float) -> void:
	max_light = maxf(p_max, 0.0)
	light = clampf(p_start, 0.0, max_light)
	drain_per_sec = maxf(p_drain, 0.0)
	mote_gain = maxf(p_gain, 0.0)
	hit_loss = maxf(p_hit, 0.0)


## Builds a meter from the "light" block of the game config.
static func from_config(light_cfg: Dictionary) -> LightMeter:
	return LightMeter.new(
		float(light_cfg.get("max", 100.0)),
		float(light_cfg.get("start", 70.0)),
		float(light_cfg.get("drain_per_sec", 5.0)),
		float(light_cfg.get("mote_gain", 12.0)),
		float(light_cfg.get("hit_loss", 20.0)))


## Drains light for [param delta] seconds; never goes below 0.
func tick(delta: float) -> void:
	light = maxf(0.0, light - drain_per_sec * maxf(delta, 0.0))


## Adds the mote gain; never exceeds max_light.
func collect_mote() -> void:
	light = minf(max_light, light + mote_gain)


## Removes the hit loss; never goes below 0.
func take_hit() -> void:
	light = maxf(0.0, light - hit_loss)


## True when the light has run out (the run is lost).
func is_out() -> bool:
	return light <= 0.0


## Light as a fraction of max, in [0, 1].
func ratio() -> float:
	return light / max_light if max_light > 0.0 else 0.0
