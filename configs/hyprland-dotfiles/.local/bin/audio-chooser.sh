#!/bin/bash

# Define um arquivo temporário para a lista
list_file="/tmp/audio_sinks_list"
: > "$list_file"

# Obtém os IDs dos sinks (Destinos)
sinks=$(pactl list short sinks | cut -f1)

for id in $sinks; do
    # Para cada ID, obtém a descrição legível
    # Procura por "Destino #ID", pega as próximas linhas, filtra "Descrição:", pega o valor
    desc=$(pactl list sinks | grep -A 10 "Destino #$id" | grep "Descrição:" | head -n 1 | cut -d: -f2 | xargs)
    
    # Fallback: Se não achar "Descrição" (alguns sistemas misturam), tenta "Description"
    if [ -z "$desc" ]; then
        desc=$(pactl list sinks | grep -A 10 "Sink #$id" | grep "Description:" | head -n 1 | cut -d: -f2 | xargs)
    fi

    # Salva no formato "ID: Descrição"
    echo "$id: $desc" >> "$list_file"
done

# Mostra o menu wofi
selected=$(wofi --dmenu --prompt "Saída de Áudio" --height 20% --width 40% --cache-file /dev/null < "$list_file")

# Se algo foi selecionado, define como padrão
if [ -n "$selected" ]; then
    id=$(echo "$selected" | cut -d':' -f1)
    pactl set-default-sink "$id"
    desc=$(echo "$selected" | cut -d':' -f2-)
    notify-send "Áudio Alterado" "$desc"
fi
