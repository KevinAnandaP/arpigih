class_name TrainingDummy
extends CharacterBody2D

signal dummy_reset()

@export var max_health: float = 250.0
@export var max_poise: float = 60.0
@export var attack_interval: float = 4.0
@export var telegraph_duration: float = 0.8

@onready var health_comp: HealthComponent = $HealthComponent
@onready var poise_comp: PoiseComponent = $PoiseComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $AttackPivot/HitboxComponent
@onready var attack_pivot: Node2D = $AttackPivot
@onready var visual: Node2D = $Visual
@onready var telegraph_ring: Line2D = $TelegraphRing
@onready var stagger_icon: Node2D = $StaggerIcon

var is_staggered: bool = false
var _attack_timer: float = 2.0
var _is_telegraphing: bool = false
var _telegraph_timer: float = 0.0
var _target_player: Node2D = null

func _ready() -> void:
	hitbox.attacker_owner = self
	hitbox.monitoring = false
	telegraph_ring.visible = false
	stagger_icon.visible = false
	
	health_comp.max_health = max_health
	health_comp.current_health = max_health
	poise_comp.max_poise = max_poise
	poise_comp.current_poise = max_poise
	
	health_comp.damaged.connect(_on_damaged)
	health_comp.died.connect(_on_died)
	poise_comp.poise_broken.connect(_on_poise_broken)
	poise_comp.poise_recovered.connect(_on_poise_recovered)
	hurtbox.hit_received.connect(_on_hit_received)
	
	_draw_telegraph_circle()

func _physics_process(delta: float) -> void:
	if health_comp.is_dead or is_staggered:
		velocity = Vector2.ZERO
		return
	
	_find_player()
	
	if _target_player:
		var dir := (_target_player.global_position - global_position).normalized()
		attack_pivot.rotation = dir.angle()
	
	if _is_telegraphing:
		_telegraph_timer -= delta
		# Pulse telegraph visual
		var t: float = 1.0 - (_telegraph_timer / telegraph_duration)
		telegraph_ring.scale = Vector2.ONE * (0.5 + t * 0.7)
		telegraph_ring.modulate = Color(1.0, 0.2, 0.2, 0.4 + t * 0.6)
		
		if _telegraph_timer <= 0.0:
			_execute_attack()
	else:
		_attack_timer -= delta
		if _attack_timer <= 0.0:
			_start_telegraph()

func _find_player() -> void:
	if not _target_player:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_target_player = players[0]

func _start_telegraph() -> void:
	_is_telegraphing = true
	_telegraph_timer = telegraph_duration
	telegraph_ring.visible = true
	EventBus.combat_log_message.emit("Enemy telegraphing strike! Get ready to Dodge or Parry!")

func _execute_attack() -> void:
	_is_telegraphing = false
	telegraph_ring.visible = false
	_attack_timer = attack_interval
	
	# Swing attack
	hitbox.damage = 25.0
	hitbox.poise_damage = 30.0
	hitbox.is_parryable = true
	hitbox.monitoring = true
	
	var tween := create_tween()
	attack_pivot.rotation -= 1.0
	tween.tween_property(attack_pivot, "rotation", attack_pivot.rotation + 2.0, 0.15)
	
	await get_tree().create_timer(0.2).timeout
	hitbox.monitoring = false

func _on_hit_received(incoming: HitboxComponent) -> void:
	# Flash white
	var tween := create_tween()
	visual.modulate = Color(2.0, 2.0, 2.0, 1.0)
	tween.tween_property(visual, "modulate", Color.WHITE, 0.15)

func _on_damaged(amount: float, _source: Node2D) -> void:
	EventBus.combat_log_message.emit("Dummy hit for " + str(snapped(amount, 0.1)) + " dmg. Poise: " + str(snapped(poise_comp.current_poise, 1)) + "/" + str(poise_comp.max_poise))

func _on_poise_broken() -> void:
	is_staggered = true
	_is_telegraphing = false
	telegraph_ring.visible = false
	stagger_icon.visible = true
	hitbox.monitoring = false
	visual.modulate = Color(1.0, 0.9, 0.3, 1.0) # Yellow stagger
	EventBus.combat_log_message.emit(">>> DUMMY POISE BROKEN! Staggered for 2.5s! <<<")

func _on_poise_recovered() -> void:
	is_staggered = false
	stagger_icon.visible = false
	visual.modulate = Color.WHITE
	_attack_timer = 2.0
	EventBus.combat_log_message.emit("Dummy recovered from stagger.")

func _on_died() -> void:
	_is_telegraphing = false
	telegraph_ring.visible = false
	stagger_icon.visible = false
	hitbox.monitoring = false
	visible = false
	EventBus.combat_log_message.emit("Dummy defeated! Respawning in 3 seconds...")
	await get_tree().create_timer(3.0).timeout
	_respawn()

func _respawn() -> void:
	health_comp.is_dead = false
	health_comp.current_health = max_health
	poise_comp.is_staggered = false
	poise_comp.current_poise = max_poise
	is_staggered = false
	visible = true
	visual.modulate = Color.WHITE
	_attack_timer = 2.5
	emit_signal("dummy_reset")
	EventBus.combat_log_message.emit("Training Dummy respawned.")

func _draw_telegraph_circle() -> void:
	var points := PackedVector2Array()
	var segments := 24
	var radius := 32.0
	for i in range(segments + 1):
		var angle := (float(i) / float(segments)) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	telegraph_ring.points = points
	telegraph_ring.width = 2.0
	telegraph_ring.default_color = Color(1.0, 0.2, 0.2, 0.8)
