#!/bin/bash

# Opções do Wofi
WOFI_CMD=(
    wofi
    --dmenu
    --append
    --location 3
    --xoffset -100
    --yoffset 50
    --width 300
    --height 400
    --cache-file /dev/null
)

while true; do
    # Obtém a lista de redes
    LIST=$(nmcli --terse --fields "NAME,TYPE,STATE" connection show --active | grep -v "loopback")
    WIFI_LIST=$(nmcli --terse --fields "SSID,BARS,SECURITY" device wifi list --rescan yes)
    
    # Constrói o menu
    MENU_OPTIONS="󰖩  Refresh\n"
    
    # Adiciona redes Wi-Fi disponíveis
    while IFS=: read -r ssid bars security;
 do
        if [ -n "$ssid" ]; then
            # Marca se já estiver conectado
            if echo "$LIST" | grep -q "^$ssid"; then
                MENU_OPTIONS+="󰄵  $ssid ($bars) [Connected]\n"
            else
                ICON=$([ -n "$security" ] && echo "󰤪" || echo "󰤨")
                MENU_OPTIONS+="$ICON  $ssid ($bars)\n"
            fi
        fi
    done <<< "$WIFI_LIST"

    # Mostra o menu
    CHOICE=$(printf "%b" "$MENU_OPTIONS" | "${WOFI_CMD[@]}" --prompt "Wi-Fi Networks")
    
    if [ -z "$CHOICE" ]; then
        exit 0
    fi

    SSID=$(echo "$CHOICE" | sed -E 's/^[^ ]*  //' | sed -E 's/ \([^)]+\)( \[Connected\])?$//')

    if [[ "$CHOICE" == *"Refresh"* ]]; then
        continue
    elif [[ "$CHOICE" == *"[Connected]"* ]]; then
        nmcli connection down "$SSID"
    else
        # Tenta conectar usando 'device wifi connect' que gerencia perfis salvos automaticamente
        notify-send "Wi-Fi" "Connecting to: $SSID..."
        
        # Tenta conectar (usará perfil salvo se existir)
        if OUTPUT=$(nmcli device wifi connect "$SSID" 2>&1); then
            notify-send "Wi-Fi" "Connected to $SSID"
        else
            # Se falhar pedindo senha ou segredos (suporte a PT-BR e EN)
            if echo "$OUTPUT" | grep -Eq "secrets|Segredos"; then
                PASS=$("${WOFI_CMD[@]}" --password --prompt "Password for $SSID" < /dev/null)
                if [ -n "$PASS" ]; then
                    notify-send "Wi-Fi" "Retrying with password..."
                    if nmcli device wifi connect "$SSID" password "$PASS"; then
                        notify-send "Wi-Fi" "Connected to $SSID"
                    else
                        notify-send -u critical "Wi-Fi" "Failed to connect"
                    fi
                fi
            else
                # Outro erro (ex: timeout, interface busy)
                notify-send -u critical "Wi-Fi" "Error connecting: $OUTPUT"
            fi
        fi
    fi
    exit 0
done
