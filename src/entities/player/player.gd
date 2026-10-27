class_name Player
extends CharacterBody2D

enum State { IDLE, MOVE, ATTACK_LIGHT, ATTACK_HEAVY, DODGE, PARRY, GUARD, STAGGER, DEAD }

@export var move_speed: float = 140.0
@export var acceleration: float = 800.0
@export var friction: float = 700.0

@export var dodge_speed: float = 260.0
@export var dodge_duration: float = 0.35
@export var dodge_stamina_cost: float = 20.0

@export var light_attack_stamina_cost: float = 12.0
@export var heavy_attack_stamina_cost: float = 35.0
@export var parry_stamina_cost: float = 15.0

@onready var health_comp: HealthComponent = $HealthComponent
@onready var stamina_comp: StaminaComponent = $StaminaComponent
@onready var mana_comp: ManaComponent = $ManaComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $WeaponPivot/HitboxComponent
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var visual: Node2D = $Visual
@onready var parry_spark: Node2D = $ParrySpark

var current_state: State = State.IDLE
var facing_direction: Vector2 = Vector2.RIGHT
var roll_direction: Vector2 = Vector2.RIGHT
var state_timer: float = 0.0
var combo_index: int = 1
var is_charging_heavy: bool = false
var heavy_charge_timer: float = 0.0

func reset_to_idle() -> void:
	current_state = State.IDLE
	velocity = Vector2.ZERO
	if health_comp:
		health_comp.set_invulnerable(false)
	if hitbox:
		hitbox.monitoring = false

func _ready() -> void:
	hitbox.attacker_owner = self
	hitbox.monitoring = false
	hitbox.monitorable = true
	
	health_comp.damaged.connect(_on_health_damaged)
	health_comp.died.connect(_on_health_died)
	hurtbox.hit_received.connect(_on_hurtbox_hit_received)
	
	EventBus.combat_log_message.emit("Hero enters the arena. Ready for combat!")

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	_update_facing_direction()
	
	match current_state:
		State.IDLE, State.MOVE:
			_handle_movement(delta)
			_handle_combat_inputs()
		State.DODGE:
			_process_dodge(delta)
		State.ATTACK_LIGHT:
			_process_attack_light(delta)
		State.ATTACK_HEAVY:
			_process_attack_heavy(delta)
		State.PARRY:
			_process_parry(delta)
		State.GUARD:
			_process_guard(delta)
		State.STAGGER:
			_process_stagger(delta)
	
	move_and_slide()

func _update_facing_direction() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var to_mouse: Vector2 = (mouse_pos - global_position).normalized()
	if to_mouse.length() > 0.1:
		facing_direction = to_mouse
		weapon_pivot.rotation = facing_direction.angle()
		if visual.has_node("Sprite"):
			visual.get_node("Sprite").scale.x = -1.0 if facing_direction.x < 0 else 1.0

func _handle_movement(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * move_speed, acceleration * delta)
		current_state = State.MOVE
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		current_state = State.IDLE

func _handle_combat_inputs() -> void:
	# Dodge Roll
	if Input.is_action_just_pressed("dodge"):
		if stamina_comp.can_afford(dodge_stamina_cost):
			stamina_comp.consume(dodge_stamina_cost)
			_start_dodge()
			return
		else:
			EventBus.combat_log_message.emit("Not enough stamina to dodge!")
	
	# Parry (Q)
	if Input.is_action_just_pressed("parry"):
		if stamina_comp.can_afford(parry_stamina_cost):
			stamina_comp.consume(parry_stamina_cost)
			_start_parry()
			return
	
	# Guard (Shift/E)
	if Input.is_action_pressed("guard"):
		_start_guard()
		return
	
	# Light Attack (LMB)
	if Input.is_action_just_pressed("attack_light"):
		if stamina_comp.can_afford(light_attack_stamina_cost):
			stamina_comp.consume(light_attack_stamina_cost)
			_start_light_attack()
			return
		else:
			EventBus.combat_log_message.emit("Stamina depleted! Cannot attack.")
	
	# Heavy Attack (RMB)
	if Input.is_action_just_pressed("attack_heavy"):
		if stamina_comp.can_afford(heavy_attack_stamina_cost):
			_start_heavy_attack()
			return

func _start_dodge() -> void:
	current_state = State.DODGE
	state_timer = dodge_duration
	roll_direction = velocity.normalized() if velocity.length() > 10.0 else facing_direction
	velocity = roll_direction * dodge_speed
	health_comp.set_invulnerable(true)
	EventBus.combat_log_message.emit("Dodge roll! (I-frames active)")

func _process_dodge(delta: float) -> void:
	state_timer -= delta
	velocity = velocity.move_toward(Vector2.ZERO, friction * 0.5 * delta)
	if state_timer <= 0.0:
		health_comp.set_invulnerable(false)
		current_state = State.IDLE

func _start_parry() -> void:
	current_state = State.PARRY
	state_timer = 0.25 # Parry window duration
	velocity = Vector2.ZERO
	EventBus.combat_log_message.emit("Parry stance raised!")

func _process_parry(delta: float) -> void:
	state_timer -= delta
	if state_timer <= 0.0:
		current_state = State.IDLE

func _start_guard() -> void:
	current_state = State.GUARD
	velocity = Vector2.ZERO

func _process_guard(_delta: float) -> void:
	if not Input.is_action_pressed("guard"):
		current_state = State.IDLE
		return
	velocity = Vector2.ZERO

func _start_light_attack() -> void:
	current_state = State.ATTACK_LIGHT
	state_timer = 0.28
	velocity = facing_direction * 60.0 # Small lunge
	hitbox.damage = 18.0 + (combo_index * 4.0)
	hitbox.poise_damage = 15.0
	hitbox.monitoring = true
	_animate_swing()
	EventBus.combat_log_message.emit("Light Attack #" + str(combo_index) + " executed.")
	combo_index = (combo_index % 3) + 1

func _process_attack_light(delta: float) -> void:
	state_timer -= delta
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if state_timer <= 0.0:
		hitbox.monitoring = false
		current_state = State.IDLE

func _start_heavy_attack() -> void:
	current_state = State.ATTACK_HEAVY
	is_charging_heavy = true
	heavy_charge_timer = 0.0
	velocity = Vector2.ZERO
	EventBus.combat_log_message.emit("Charging heavy attack...")

func _process_attack_heavy(delta: float) -> void:
	if is_charging_heavy:
		heavy_charge_timer += delta
		if Input.is_action_just_released("attack_heavy") or heavy_charge_timer >= 1.0:
			is_charging_heavy = false
			stamina_comp.consume(heavy_attack_stamina_cost)
			state_timer = 0.35
			velocity = facing_direction * 180.0 # Big lunge
			var charge_factor: float = clampf(heavy_charge_timer / 1.0, 0.5, 1.5)
			hitbox.damage = 45.0 * charge_factor
			hitbox.poise_damage = 40.0 * charge_factor
			hitbox.monitoring = true
			_animate_heavy_swing()
			EventBus.combat_log_message.emit("HEAVY SMASH unleashed! Damage: " + str(snapped(hitbox.damage, 0.1)))
	else:
		state_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if state_timer <= 0.0:
			hitbox.monitoring = false
			current_state = State.IDLE

func _process_stagger(delta: float) -> void:
	state_timer -= delta
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if state_timer <= 0.0:
		current_state = State.IDLE

func _animate_swing() -> void:
	var tween := create_tween()
	weapon_pivot.rotation = facing_direction.angle() - 0.9
	tween.tween_property(weapon_pivot, "rotation", facing_direction.angle() + 0.9, 0.18)

func _animate_heavy_swing() -> void:
	var tween := create_tween()
	weapon_pivot.rotation = facing_direction.angle() - 1.4
	tween.tween_property(weapon_pivot, "rotation", facing_direction.angle() + 1.4, 0.25)

func _on_hurtbox_hit_received(incoming_hitbox: HitboxComponent) -> void:
	if current_state == State.DODGE:
		return
	
	if current_state == State.PARRY and incoming_hitbox.is_parryable:
		# Successful parry!
		EventBus.combat_log_message.emit(">>> PERFECT PARRY! Enemy staggered! <<<")
		EventBus.parry_attempted.emit(true)
		if incoming_hitbox.attacker_owner and incoming_hitbox.attacker_owner.has_node("PoiseComponent"):
			var enemy_poise = incoming_hitbox.attacker_owner.get_node("PoiseComponent") as PoiseComponent
			enemy_poise.damage_poise(100.0) # Instant stagger on parry
		return
	
	if current_state == State.GUARD:
		var guard_cost: float = incoming_hitbox.damage * 0.8
		if stamina_comp.can_afford(guard_cost):
			stamina_comp.consume(guard_cost)
			EventBus.combat_log_message.emit("Guard held! Damage mitigated.")
			return
		else:
			EventBus.combat_log_message.emit("Guard broken! Guard crushed.")
			current_state = State.STAGGER
			state_timer = 1.2
	
	# Normal hit taken
	EventBus.player_damaged.emit(health_comp.current_health, health_comp.max_health, incoming_hitbox.damage)

func _on_health_damaged(amount: float, _source: Node2D) -> void:
	EventBus.combat_log_message.emit("Hero took " + str(snapped(amount, 0.1)) + " damage!")
	var tween := create_tween()
	visual.modulate = Color(1.5, 0.3, 0.3, 1.0)
	tween.tween_property(visual, "modulate", Color.WHITE, 0.2)

func _on_health_died() -> void:
	current_state = State.DEAD
	velocity = Vector2.ZERO
	EventBus.combat_log_message.emit("YOU DIED. Defeated in battle.")
	EventBus.player_died.emit()
