#!/bin/bash
# ~/.config/hypr/scripts/float-next.sh
# Escuta o próximo evento de abertura de janela no Hyprland e a torna flutuante.

# Garante que a assinatura do Hyprland está setada para hyprctl e socat
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Busca a assinatura a partir dos diretórios de instância disponíveis.
    SIGNATURE=$(find "/run/user/$(id -u)/hypr" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | head -n 1)
    if [ -n "$SIGNATURE" ]; then
        export HYPRLAND_INSTANCE_SIGNATURE="$SIGNATURE"
    fi
fi

# Localiza o socket de eventos (socket2)
USER_ID=$(id -u)
# Caminhos mais comuns
SOCKET_PATH="/run/user/$USER_ID/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Se o caminho padrão falhar, busca recursivamente
if [ ! -S "$SOCKET_PATH" ]; then
    SOCKET_PATH=$(find "/run/user/$USER_ID/hypr" -name ".socket2.sock" 2>/dev/null | head -n 1)
fi

# Fallback para /tmp
if [ -z "$SOCKET_PATH" ] || [ ! -S "$SOCKET_PATH" ]; then
    SOCKET_PATH=$(find /tmp/hypr -name ".socket2.sock" 2>/dev/null | head -n 1)
fi

# Se ainda não encontrou ou não tem socat, apenas executa
if ! command -v socat &> /dev/null || [ -z "$SOCKET_PATH" ]; then
    "$@"
    exit
fi

# Inicia o monitor em background
(
    # Timeout de 15 segundos (se nada for aberto)
    { sleep 15; kill $$ 2>/dev/null; } &
    timeout_pid=$!

    # Escuta o socket
    socat -U - UNIX-CONNECT:"$SOCKET_PATH" | while read -r line; do
        if [[ $line == openwindow* ]]; then
            # Evento: openwindow>>ADDR,WS,CLASS,TITLE
            # Precisamos do endereço sem o "openwindow>>"
            addr=$(echo "$line" | cut -d',' -f1 | sed 's/openwindow>>//')
            class=$(echo "$line" | cut -d',' -f3)

            # Ignora o wofi (geralmente é layer, mas por segurança)
            if [[ "$class" == "wofi" ]]; then
                continue
            fi
            
            # Pequeno delay para garantir que a janela esteja mapeada
            sleep 0.15
            
            # Torna flutuante, centraliza e redimensiona
            # Endereço precisa do prefixo 0x se for hex de 12 caracteres (padrão Hyprland)
            hyprctl dispatch togglefloating "address:0x$addr"
            hyprctl dispatch centerwindow "address:0x$addr"
            hyprctl dispatch resizewindowpixel exact 1000 700,"address:0x$addr"
            
            kill $timeout_pid 2>/dev/null
            exit 0
        fi
    done
) &

# Executa o comando passado
"$@"
