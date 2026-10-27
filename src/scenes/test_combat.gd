class_name TestCombatScene
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var pause_overlay: Control = $PauseOverlay

var is_paused: bool = false

func _ready() -> void:
	EventBus.player_died.connect(_on_player_died)
	EventBus.game_paused.connect(_on_game_paused)
	
	# Sync player components to HUD on ready
	await get_tree().process_frame
	var hp := player.get_node("HealthComponent") as HealthComponent
	var st := player.get_node("StaminaComponent") as StaminaComponent
	var mn := player.get_node("ManaComponent") as ManaComponent
	
	hp.health_changed.connect(func(cur, mx): _sync_hp(cur, mx))
	st.stamina_changed.connect(func(cur, mx): EventBus.stamina_changed.emit(cur, mx))
	mn.mana_changed.connect(func(cur, mx): EventBus.mana_changed.emit(cur, mx))
	
	_sync_hp(hp.current_health, hp.max_health)
	EventBus.stamina_changed.emit(st.current_stamina, st.max_stamina)
	EventBus.mana_changed.emit(mn.current_mana, mn.max_mana)

func _sync_hp(cur: float, mx: float) -> void:
	EventBus.player_damaged.emit(cur, mx, 0.0)

func _input(event: InputEvent) -> void:
	if event.is_action_just_pressed("pause"):
		GameState.toggle_pause()

func _on_game_paused(paused: bool) -> void:
	pause_overlay.visible = paused

func _on_player_died() -> void:
	# Respawn after 2 seconds at spawn point
	await get_tree().create_timer(2.0).timeout
	var player_hp := player.get_node("HealthComponent") as HealthComponent
	var player_st := player.get_node("StaminaComponent") as StaminaComponent
	player_hp.is_dead = false
	player_hp.current_health = player_hp.max_health
	player_st.current_stamina = player_st.max_stamina
	# Reset player state
	if player.has_method("reset_to_idle"):
		player.reset_to_idle()
	player.global_position = Vector2(320, 180)
	EventBus.combat_log_message.emit("Revived at the Ember Hearth checkpoint.")
	_sync_hp(player_hp.current_health, player_hp.max_health)
