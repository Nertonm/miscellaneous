#!/bin/bash

# Configurações
TEMP_FILE="$HOME/.cache/hyprsunset_temp"
DEFAULT_TEMP=3000
STEP=500
MIN_TEMP=1000
MAX_TEMP=10000

# Garantir diretório de cache
mkdir -p "$(dirname "$TEMP_FILE")"

# Inicializa temperatura se não existir
[ ! -f "$TEMP_FILE" ] && echo "$DEFAULT_TEMP" > "$TEMP_FILE"
CURRENT_TEMP=$(cat "$TEMP_FILE")

# Função para garantir que o processo está rodando e aplicar a temperatura
apply_temp() {
    local temp=$1
    if ! pgrep -x "hyprsunset" > /dev/null; then
        # Se não estiver rodando, inicia o processo com a temperatura desejada
        hyprsunset --temperature "$temp" &
        sleep 0.2 # Pequeno delay para o socket ser criado
    else
        # Se já estiver rodando, usa o hyprctl para mudança instantânea
        hyprctl hyprsunset temperature "$temp" > /dev/null 2>&1
    fi
    echo "$temp" > "$TEMP_FILE"
}

case "$1" in
    up)
        NEW_TEMP=$((CURRENT_TEMP + STEP))
        [ "$NEW_TEMP" -gt "$MAX_TEMP" ] && NEW_TEMP=$MAX_TEMP
        apply_temp "$NEW_TEMP"
        ;;
    down)
        NEW_TEMP=$((CURRENT_TEMP - STEP))
        [ "$NEW_TEMP" -lt "$MIN_TEMP" ] && NEW_TEMP=$MIN_TEMP
        apply_temp "$NEW_TEMP"
        ;;
    toggle)
        if pgrep -x "hyprsunset" > /dev/null; then
            killall hyprsunset
        else
            apply_temp "$CURRENT_TEMP"
        fi
        ;;
    status)
        if pgrep -x "hyprsunset" > /dev/null; then
            echo "{\"text\":\"󰖔\", \"tooltip\":\"Temperatura: ${CURRENT_TEMP}K\", \"class\":\"on\"}"
        else
            echo "{\"text\":\"󰖙\", \"tooltip\":\"Desligado\", \"class\":\"off\"}"
        fi
        ;;
esac
