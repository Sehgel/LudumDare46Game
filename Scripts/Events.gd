extends Node

#GAMEMANAGER
signal on_game_start

#INVENTORY
signal on_inventory_changed
signal on_inventory_selected_item_changed

#DRUGS
signal on_pill_taken
signal on_tablet_taken
signal on_syringe_applied

signal on_pill_disipated
signal on_tablet_disipated
signal on_syringe_disipated

#VITAL SIGNS
signal on_blood_level_update
signal on_temperature_level_update
signal on_lung_level_update

signal on_death
