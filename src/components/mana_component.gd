class_name ManaComponent
extends Node

signal mana_changed(current: float, maximum: float)

@export var max_mana: float = 100.0
@export var regen_rate: float = 12.0 # per second

var current_mana: float = 100.0

func _ready() -> void:
	current_mana = max_mana
	emit_signal("mana_changed", current_mana, max_mana)

func _process(delta: float) -> void:
	if current_mana < max_mana:
		current_mana = minf(max_mana, current_mana + regen_rate * delta)
		emit_signal("mana_changed", current_mana, max_mana)

func can_afford(cost: float) -> bool:
	return current_mana >= cost

func consume(cost: float) -> bool:
	if current_mana < cost:
		return false
	current_mana = maxf(0.0, current_mana - cost)
	emit_signal("mana_changed", current_mana, max_mana)
	return true

func restore(amount: float) -> void:
	if amount <= 0.0:
		return
	current_mana = minf(max_mana, current_mana + amount)
	emit_signal("mana_changed", current_mana, max_mana)
