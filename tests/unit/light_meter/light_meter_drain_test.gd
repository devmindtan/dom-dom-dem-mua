extends RefCounted
## Unit tests for LightMeter and Difficulty (run by tests/run_tests.gd).

const LightMeterScript := preload("res://src/core/light_meter.gd")
const DifficultyScript := preload("res://src/core/difficulty.gd")

var failures: Array[String] = []


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures.append(msg)


func _meter() -> LightMeter:
	# max, start, drain/s, mote gain, hit loss
	return LightMeterScript.new(100.0, 50.0, 10.0, 15.0, 20.0)


func test_tick_drains_by_rate_times_delta() -> void:
	var m := _meter()
	m.tick(1.5)
	_check(is_equal_approx(m.light, 35.0), "tick 1.5s should leave 35, got %s" % m.light)


func test_tick_never_goes_below_zero() -> void:
	var m := _meter()
	m.tick(100.0)
	_check(m.light == 0.0 and m.is_out(), "long tick should clamp to 0 and be out")


func test_collect_mote_caps_at_max() -> void:
	var m := _meter()
	for i in 10:
		m.collect_mote()
	_check(m.light == 100.0, "motes should cap at max, got %s" % m.light)


func test_take_hit_reduces_and_clamps() -> void:
	var m := _meter()
	m.take_hit()
	_check(is_equal_approx(m.light, 30.0), "one hit should leave 30, got %s" % m.light)
	m.take_hit(); m.take_hit()
	_check(m.light == 0.0 and m.is_out(), "three hits should clamp to 0")


func test_start_above_max_is_clamped() -> void:
	var m := LightMeterScript.new(100.0, 250.0, 1.0, 1.0, 1.0)
	_check(m.light == 100.0 and is_equal_approx(m.ratio(), 1.0), "start should clamp to max")


func test_zero_max_ratio_is_zero() -> void:
	var m := LightMeterScript.new(0.0, 10.0, 1.0, 1.0, 1.0)
	_check(m.ratio() == 0.0, "ratio with max 0 should be 0")


func test_from_config_reads_values() -> void:
	var m := LightMeterScript.from_config({"max": 80.0, "start": 40.0, "drain_per_sec": 2.0,
		"mote_gain": 5.0, "hit_loss": 9.0})
	_check(m.max_light == 80.0 and m.light == 40.0 and m.hit_loss == 9.0, "from_config mismatch")


func test_rain_interval_shrinks_then_floors() -> void:
	_check(is_equal_approx(DifficultyScript.rain_interval(0.5, 0.1, 0.01, 10.0), 0.4), "interval at 10s")
	_check(DifficultyScript.rain_interval(0.5, 0.1, 0.01, 1000.0) == 0.1, "interval floors at min")
	_check(DifficultyScript.rain_interval(0.5, 0.1, 0.01, -5.0) == 0.5, "negative time treated as 0")


func test_speed_bonus_grows_linearly() -> void:
	_check(is_equal_approx(DifficultyScript.speed_bonus(2.5, 4.0), 10.0), "speed bonus at 4s")
