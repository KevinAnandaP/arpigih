extends Node

## Centralized EventBus for decoupled communication across systems

# Combat signals
signal player_damaged(current_hp: float, max_hp: float, damage_taken: float)
signal player_healed(current_hp: float, max_hp: float, heal_amount: float)
signal player_died()

signal stamina_changed(current_stamina: float, max_stamina: float)
signal stamina_exhausted()
signal stamina_recovered()

signal mana_changed(current_mana: float, max_mana: float)

signal parry_attempted(success: bool)
signal parry_riposte_ready(target: Node2D)
signal poise_broken(target: Node2D)

signal elemental_reaction_triggered(reaction_name: String, position: Vector2, reaction_data: Dictionary)
signal status_effect_applied(target: Node2D, status_name: String, duration: float)

# Game & UI signals
signal game_paused(is_paused: bool)
signal command_wheel_opened()
signal command_wheel_selected(command_id: String)
signal checkpoint_reached(checkpoint_id: String, checkpoint_name: String)
signal combat_log_message(message: String)
