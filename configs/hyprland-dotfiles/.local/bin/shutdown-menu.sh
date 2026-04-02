#!/bin/bash
# Menu simples para confirmar desligamento usando wofi

if echo -e "❌ Desligar
↩️ Cancelar" | wofi --dmenu --width 250 --height 150 --prompt "Desligar Computador?" --cache-file /dev/null | grep -q "Desligar"; then
    systemctl poweroff
fi

