#!/bin/bash

# Cores (Hyprland Theme)
CYAN='\033[1;36m'   # Títulos
ORANGE='\033[1;33m' # Atalhos (Destaque)
GRAY='\033[0;90m'   # Rótulos/Separadores
NC='\033[0m'        # No Color

# Função para imprimir uma seção inteira
print_section() {
    local title="$1"
    shift
    echo -e "${CYAN}:: $title ::${NC}"
    local line=""
    while [ "$#" -gt 0 ]; do
        local label="$1"
        local key="$2"
        local item="${GRAY}${label} ${ORANGE}${key}${NC}"
        if [ -z "$line" ]; then
            line="  $item"
        else
            line="$line   ${GRAY}│${NC}   $item"
        fi
        shift 2
    done
    echo -e "$line"
    echo ""
}

# --- CONTEÚDO ---

print_section "SESSÕES & ABAS" \
    "Desconectar" "Pre + d" \
    "Nova Aba" "Ctrl + t" \
    "Listar" "Pre + w/s" \
    "Renomear" "Pre + ,/$" \
    "Nav Abas" "Shift + ←/→"

print_section "MOVIMENTAÇÃO (PAINÉIS)" \
    "Foco" "Alt + Setas / hjkl" \
    "Vertical" "Pre + |" \
    "Horizontal" "Pre + -" \
    "Zoom" "Pre + z"

print_section "SISTEMA & KITTY" \
    "Copiar/Colar" "C+S+c/v" \
    "Fonte" "C+S+±" \
    "Recarregar" "Pre + r" \
    "Sair Terminal" "tmux a (CLI)"