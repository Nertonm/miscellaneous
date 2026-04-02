#!/bin/bash
if ! pgrep -x "dunst" > /dev/null; then
    notify-send "Erro" "O Dunst não está rodando."
    exit 1
fi

# Tenta obter o histórico com um timeout curto
dunstctl history | jq -r ".data[0] | reverse | .[] | \"\(.summary.data): \(.body.data)\"" | wofi --dmenu -p "Notificações" --width 500 --height 400
