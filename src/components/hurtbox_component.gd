class_name HurtboxComponent
extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var health_comp: HealthComponent
@export var poise_comp: PoiseComponent

func _ready() -> void:
	collision_layer = 0
	collision_mask = 4 # Detects hitboxes
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox := area as HitboxComponent
		emit_signal("hit_received", hitbox)
		
		# Apply damage to health
		if health_comp:
			health_comp.take_damage(hitbox.damage, hitbox.attacker_owner)
		
		# Apply poise damage
		if poise_comp:
			poise_comp.damage_poise(hitbox.poise_damage)
