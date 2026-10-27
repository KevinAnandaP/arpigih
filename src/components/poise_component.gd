class_name PoiseComponent
extends Node

signal poise_changed(current: float, maximum: float)
signal poise_broken()
signal poise_recovered()

@export var max_poise: float = 50.0
@export var recovery_rate: float = 15.0 # per second
@export var stagger_duration: float = 2.5 # duration in seconds when poise breaks

var current_poise: float = 50.0
var is_staggered: bool = false
var _stagger_timer: float = 0.0

func _ready() -> void:
	current_poise = max_poise
	emit_signal("poise_changed", current_poise, max_poise)

func _process(delta: float) -> void:
	if is_staggered:
		_stagger_timer -= delta
		if _stagger_timer <= 0.0:
			is_staggered = false
			current_poise = max_poise
			emit_signal("poise_recovered")
			emit_signal("poise_changed", current_poise, max_poise)
		return
	
	if current_poise < max_poise:
		current_poise = minf(max_poise, current_poise + recovery_rate * delta)
		emit_signal("poise_changed", current_poise, max_poise)

func damage_poise(amount: float) -> bool:
	if is_staggered:
		return true
	
	current_poise = maxf(0.0, current_poise - amount)
	emit_signal("poise_changed", current_poise, max_poise)
	
	if current_poise <= 0.0:
		is_staggered = true
		_stagger_timer = stagger_duration
		emit_signal("poise_broken")
		return true
	
	return false
