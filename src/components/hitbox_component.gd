class_name HitboxComponent
extends Area2D

@export var damage: float = 15.0
@export var poise_damage: float = 15.0
@export var knockback_force: float = 120.0
@export var element_type: String = "Physical" # Physical, Fire, Frost, Lightning, Nature, Holy, Void
@export var is_parryable: bool = true

var attacker_owner: Node2D

func _ready() -> void:
	collision_layer = 4 # Hitbox layer
	collision_mask = 0  # Does not detect, hurtbox detects hitbox
	monitoring = false
	monitorable = false # Inactive until activated by an attack action

func set_active(active: bool) -> void:
	monitoring = active
	monitorable = active
