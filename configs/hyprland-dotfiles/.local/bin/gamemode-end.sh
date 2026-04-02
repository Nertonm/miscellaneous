#!/bin/bash
# --- GameMode End Script ---

# Restaura as configurações originais do Hyprland (conforme hyprland.conf)
hyprctl keyword decoration:blur:enabled 1
hyprctl keyword decoration:shadow:enabled 1
hyprctl keyword animations:enabled 1

hyprctl keyword general:gaps_in 5
hyprctl keyword general:gaps_out 10
hyprctl keyword general:border_size 2
hyprctl keyword decoration:rounding 10

# Notifica
notify-send -u low -t 3000 "🏁 GameMode OFF" "Configurações Restauradas"
