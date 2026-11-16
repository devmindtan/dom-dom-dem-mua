class_name Difficulty
extends RefCounted
## Difficulty curves for the rain, as pure functions of elapsed run time.


## Seconds between raindrops: shrinks linearly from [param start] by
## [param ramp] per second, never below [param min_interval].
static func rain_interval(start: float, min_interval: float, ramp: float, elapsed: float) -> float:
	return maxf(min_interval, start - ramp * maxf(elapsed, 0.0))


## Extra fall speed added to every new drop after [param elapsed] seconds.
static func speed_bonus(ramp: float, elapsed: float) -> float:
	return ramp * maxf(elapsed, 0.0)
