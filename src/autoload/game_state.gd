extends Node

## Global Game State (Single-Player)

enum GameMode { EXPLORATION, COMBAT, DIALOGUE, MENU }
enum Difficulty { STORY, NORMAL, HARD }

@export var current_mode: GameMode = GameMode.EXPLORATION
@export var current_difficulty: Difficulty = Difficulty.NORMAL

# Active Character Profile
var selected_race: String = "Ashborn"
var selected_class: String = "Warden"
var character_level: int = 1
var gold: int = 0
var ember_essence: int = 0

# Checkpoint & World State
var active_checkpoint_id: String = "hearthstone_start"
var is_game_paused: bool = false

# Active Companion setup
var active_companion_id: String = "kaelen"
var companion_posture: String = "defensive" # aggressive, defensive, support, hold

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func toggle_pause() -> void:
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
	EventBus.game_paused.emit(is_game_paused)

func set_companion_posture(new_posture: String) -> void:
	companion_posture = new_posture
	EventBus.combat_log_message.emit("Companion posture set to: " + new_posture.to_upper())
