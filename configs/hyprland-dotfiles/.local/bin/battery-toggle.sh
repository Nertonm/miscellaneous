#!/bin/bash

LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr_battery_mode"

# Se o script for chamado com "status", ele apenas retorna o JSON para o Waybar
if [ "$1" == "status" ]; then
    if [ -f "$LOCK_FILE" ]; then
        echo '{"text": "🍃", "tooltip": "Modo Bateria (60Hz | Sem Efeitos)", "class": "battery"}'
    else
        echo '{"text": "🚀", "tooltip": "Modo Performance (165Hz | Efeitos On)", "class": "performance"}'
    fi
    exit 0
fi

# Lógica de Troca (Toggle)
if [ -f "$LOCK_FILE" ]; then
    # --- VOLTAR PARA PERFORMANCE ---
    hyprctl keyword monitor "eDP-1,1920x1080@165,0x0,1"
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:shadow:enabled true
    hyprctl keyword animations:enabled true
    
    rm "$LOCK_FILE"
    notify-send -u low -t 2000 "🚀 Modo Performance" "165Hz restaurado"
else
    # --- ATIVAR ECONOMIA ---
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:shadow:enabled false
    hyprctl keyword animations:enabled false
    
    touch "$LOCK_FILE"
    notify-send -u normal -t 2000 "🍃 Modo Bateria" "60Hz ativado"
fi

# Avisa a Waybar para atualizar o módulo (Sinal 8)
pkill -SIGRTMIN+8 waybar
