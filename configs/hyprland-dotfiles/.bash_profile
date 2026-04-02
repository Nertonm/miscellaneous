# shellcheck shell=bash

# ~/.bash_profile
# Executado no login. Carrega configurações essenciais e o .bashrc.

# 1. Carrega o .bashrc (Onde estão seus aliases e funções)
if [[ -f ~/.bashrc ]] ; then
    # shellcheck source=/dev/null
    . ~/.bashrc
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# --- CONFIGURAÇÕES CRÍTICAS DO WAYLAND/NVIDIA ---

# Garante que o cursor do mouse apareça (Obrigatório para Nvidia)
export WLR_NO_HARDWARE_CURSORS=1

# Força o Firefox a rodar nativo no Wayland (Mais performance)
export MOZ_ENABLE_WAYLAND=1

# Renderizador (Opcional: Se tiver problemas gráficos no Hyprland, descomente)
# export WLR_RENDERER=gles2

# NOTA: Os aliases de Hyprland e Anki foram movidos para o .bashrc
# para evitar conflitos de configuração.
