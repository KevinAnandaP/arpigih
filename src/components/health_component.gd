class_name HealthComponent
extends Node

signal health_changed(current: float, maximum: float)
signal damaged(amount: float, source: Node2D)
signal healed(amount: float)
signal died()

@export var max_health: float = 100.0
@export var armor: float = 10.0 # Factor: 100 / (100 + armor)

var current_health: float = 100.0
var is_dead: bool = false
var is_invulnerable: bool = false

func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

func take_damage(raw_amount: float, source: Node2D = null) -> float:
	if is_dead or is_invulnerable:
		return 0.0
	
	# Souls-lite armor mitigation formula
	var armor_factor: float = 100.0 / (100.0 + maxf(0.0, armor))
	var effective_damage: float = maxf(1.0, raw_amount * armor_factor)
	
	current_health = maxf(0.0, current_health - effective_damage)
	emit_signal("damaged", effective_damage, source)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0.0 and not is_dead:
		is_dead = true
		emit_signal("died")
	
	return effective_damage

func heal(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	current_health = minf(max_health, current_health + amount)
	emit_signal("healed", amount)
	emit_signal("health_changed", current_health, max_health)

func set_invulnerable(value: bool) -> void:
	is_invulnerable = value
