class_name CombatHUD
extends CanvasLayer

@onready var hp_bar: ProgressBar = $Root/TopLeft/VBox/HPContainer/HPBar
@onready var hp_label: Label = $Root/TopLeft/VBox/HPContainer/HPLabel
@onready var stamina_bar: ProgressBar = $Root/TopLeft/VBox/StaminaContainer/StaminaBar
@onready var mana_bar: ProgressBar = $Root/TopLeft/VBox/ManaContainer/ManaBar

@onready var log_label: Label = $Root/BottomLeft/CombatLog/LogLabel
@onready var controls_hint: Label = $Root/BottomCenter/ControlsHint

var _log_messages: Array[String] = []
const MAX_LOG_LINES: int = 5

func _ready() -> void:
	EventBus.player_damaged.connect(_on_player_damaged)
	EventBus.stamina_changed.connect(_on_stamina_changed)
	EventBus.mana_changed.connect(_on_mana_changed)
	EventBus.combat_log_message.connect(_on_combat_log_message)
	EventBus.player_died.connect(_on_player_died)
	
	hp_bar.value = 100.0
	stamina_bar.value = 100.0
	mana_bar.value = 100.0
	
	_add_log("EMBERVEIL Combat Arena v0.1.0 loaded.")

func _on_player_damaged(current_hp: float, max_hp: float, _dmg: float) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "HP: " + str(int(current_hp)) + " / " + str(int(max_hp))

func _on_stamina_changed(current: float, maximum: float) -> void:
	stamina_bar.max_value = maximum
	stamina_bar.value = current

func _on_mana_changed(current: float, maximum: float) -> void:
	mana_bar.max_value = maximum
	mana_bar.value = current

func _on_combat_log_message(msg: String) -> void:
	_add_log(msg)

func _on_player_died() -> void:
	_add_log("[CRITICAL] YOU HAVE PERISHED IN BATTLE.")

func _add_log(msg: String) -> void:
	_log_messages.append(msg)
	if _log_messages.size() > MAX_LOG_LINES:
		_log_messages.pop_front()
	
	log_label.text = "\n".join(_log_messages)
