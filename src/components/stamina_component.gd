class_name StaminaComponent
extends Node

signal stamina_changed(current: float, maximum: float)
signal exhausted_state_changed(is_exhausted: bool)

@export var max_stamina: float = 100.0
@export var regen_rate: float = 35.0 # per second
@export var regen_delay_duration: float = 0.8 # seconds after action before regen starts

var current_stamina: float = 100.0
var is_exhausted: bool = false
var _delay_timer: float = 0.0

func _ready() -> void:
	current_stamina = max_stamina
	emit_signal("stamina_changed", current_stamina, max_stamina)

func _process(delta: float) -> void:
	if _delay_timer > 0.0:
		_delay_timer -= delta
		return
	
	if current_stamina < max_stamina:
		# Slower regen if exhausted until at least 25% is regained
		var effective_rate: float = regen_rate if not is_exhausted else (regen_rate * 0.5)
		current_stamina = minf(max_stamina, current_stamina + effective_rate * delta)
		
		if is_exhausted and current_stamina >= (max_stamina * 0.25):
			is_exhausted = false
			emit_signal("exhausted_state_changed", false)
		
		emit_signal("stamina_changed", current_stamina, max_stamina)

func can_afford(cost: float) -> bool:
	return not is_exhausted and current_stamina >= cost

func consume(cost: float) -> bool:
	if is_exhausted or current_stamina < cost:
		return false
	
	current_stamina = maxf(0.0, current_stamina - cost)
	_delay_timer = regen_delay_duration
	
	if current_stamina <= 0.0:
		is_exhausted = true
		emit_signal("exhausted_state_changed", true)
	
	emit_signal("stamina_changed", current_stamina, max_stamina)
	return true
