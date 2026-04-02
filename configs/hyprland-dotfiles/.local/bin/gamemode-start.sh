#!/bin/bash
# --- GameMode Start Script ---

# Desativa efeitos visuais pesados do Hyprland
hyprctl keyword decoration:blur:enabled 0
hyprctl keyword decoration:shadow:enabled 0
hyprctl keyword animations:enabled 0

# Remove bordas e gaps para imersão total
hyprctl keyword general:gaps_in 0
hyprctl keyword general:gaps_out 0
hyprctl keyword general:border_size 1
hyprctl keyword decoration:rounding 0

# Notifica
notify-send -u low -t 3000 "🎮 GameMode ON" "Modo de Desempenho Ativado"
