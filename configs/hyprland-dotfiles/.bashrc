# shellcheck shell=bash

# ~/.bashrc
# Arquivo de configuração do Bash - Reorganizado e Otimizado

# ==========================================
# 1. VARIÁVEIS DE AMBIENTE GLOBAIS (EXPORTS)
# ==========================================
# Definir PATH (ccache e rancher)
export PATH="/usr/lib/ccache/bin:$HOME/.rd/bin:$PATH"

# Editores e Histórico
export EDITOR="vim"
export HISTFILESIZE=  # Infinito
export HISTSIZE=      # Infinito

# Configurações de Input (FCITX5)
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# Navegador Padrão
export BROWSER="distrobox-host-exec xdg-open"
# export BROWSER=navegador-host # (Estava sobrescrevendo a linha acima, comentei por segurança)

# MangoHud
export MANGOHUD_CONFIGFILE="$HOME/.config/MangoHud/MangoHud.conf"
export MANGOHUD=1

# ==========================================
# 2. VERIFICAÇÃO DE SHELL INTERATIVO
# ==========================================
# Se não for interativo (scp, scripts), para por aqui.
[[ $- != *i* ]] && return

# ==========================================
# 3. OPÇÕES DO SHELL E APARÊNCIA
# ==========================================
set -o vi  # Modo VI no terminal

# Cores do ls/dir
if command -v dircolors &> /dev/null && [ -r "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
fi
# --- Configuração do Prompt (PS1) de Duas Linhas ---
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Layout:
# Linha 1: [Pasta Atual] (Git Branch)
# Linha 2: nerton@gaspar $
PS1='\[\e]0;\u@\h: \w\a\]\[\033[01;34m\]\w\[\033[00m\]$(parse_git_branch)\n\[\033[01;32m\]\u@\h\[\033[00m\]\$ '
# ==========================================
# 4. FERRAMENTAS E INICIALIZAÇÕES
# ==========================================

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.config/nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Atuin (Histórico Mágico)
eval "$(atuin init bash)"

# Zoxide (Substituto do cd)
eval "$(zoxide init bash)"
alias cd='z'

# Bash Pre-exec
# shellcheck source=/dev/null
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# Bash Completion Genérico
if [ -f ~/.bash_completion ]; then
    # shellcheck source=/dev/null
    . ~/.bash_completion
fi

# ==========================================
# 5. FUNÇÕES PERSONALIZADAS
# ==========================================

# Substitua a função inteira por esta:
function _fp_runner() {
    local MODE="$1"
    local QUERY="$2"
    local APP_ID=""
    local ENV_ARGS=()

    if [ "$MODE" == "nvidia" ]; then
        echo -e "\033[1;32m🚀 [NVIDIA] Vulkan Ativado...\033[0m"
        ENV_ARGS=(
            "--env=__NV_PRIME_RENDER_OFFLOAD=1"
            "--env=__GLX_VENDOR_LIBRARY_NAME=nvidia"
            "--env=__VK_LAYER_NV_optimus=NVIDIA_only"
        )
    else
        echo -e "\033[1;34m🍃 [INTEL] Vulkan Ativado (Nvidia Bloqueada)...\033[0m"
        # O truque: --device=!/dev/nvidia* esconde a placa Nvidia do app.
        # Assim o Vulkan só enxerga a Intel e funciona nativo.
        ENV_ARGS=(
            "--device=dri"
            "--device=!/dev/nvidia*"
        )
    fi

    # Lógica de Busca (Mantém igual)
    if flatpak list --app --columns=application | grep -Fxq "$QUERY"; then
        APP_ID="$QUERY"
    else
        APP_ID=$(flatpak list --app --columns=application | grep -i "$QUERY" | head -n 1)
    fi

    if [ -n "$APP_ID" ]; then
        echo -e "   ✅ Rodando: $APP_ID"
        flatpak run "${ENV_ARGS[@]}" "$APP_ID" "${@:3}"
    else
        echo "❌ App não encontrado."
        return 1
    fi
}

# Aliases para o runner
alias fp-nvidia='_fp_runner nvidia'
alias fp-intel='_fp_runner intel'

# Autocomplete (TAB)
_fp_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local apps
    apps=$(flatpak list --app --columns=application)
    mapfile -t COMPREPLY < <(compgen -W "${apps}" -- "${cur}")
}
complete -F _fp_completions fp-nvidia
complete -F _fp_completions fp-intel

# --- Extrator Universal ---
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.tar.xz)    tar xvJf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"        ;;
            *.Z)         uncompress "$1"   ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "Unknown file type: $1" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

# --- Buscar Arquivo ---
findfile() {
    find . -type f -iname "*$1*"
}

# --- Gentoo Emerge Env ---
emerge-env() {
    local env_name=$1
    shift
    local env_file="/etc/portage/env/${env_name}.conf"
    if [ ! -f "${env_file}" ]; then
        echo "Erro: Ficheiro de ambiente '${env_file}' não encontrado."
        return 1
    fi
    echo ">>> A carregar o ambiente customizado: ${env_name}"
    sudo bash -lc '
        set -a
        . "$1"
        set +a
        shift
        exec emerge "$@"
    ' _ "${env_file}" "$@"
}

# ==========================================
# 6. ALIASES
# ==========================================

# Navegação e Sistema
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alF'
alias eza="ls"
alias cat="bat"
alias grep='grep --color=auto'
alias please='sudo'
alias help="tldr"
alias v='vim'

# Manutenção e Backup
alias atualizar='sudo pacman -Syyuu && flatpak update && yay -Syu' # Nota: Cuidado ao usar pacman/yay no Gentoo, mas mantive se for híbrido.
alias backup='rsync -azvh --progress "$HOME/.var/" /mnt/formiga/.var && rsync -azvh --progress "$HOME/.local" /mnt/formiga/.local'
alias comprimir='sudo btrfs filesystem defrag -r -v -czstd ./'
alias extrair='extract'
alias killdocker='~/.scripts/killdocker.sh'
alias gpu='python ~/envycontrol/envycontrol.py -s'

# --- Aplicativos Flatpak & AppImages ---
# Nota: Você pode usar 'fp-nvidia NOME' agora, mas mantive os aliases curtos.

# Jogos / Emuladores
alias steam='flatpak run com.valvesoftware.Steam'
alias heroic='flatpak run com.heroicgameslauncher.hgl'
alias protonup='flatpak run net.davidotek.pupgui2'
alias rpcs3='flatpak run net.rpcs3.RPCS3'
alias pcsx2='flatpak run net.pcsx2.PCSX2'
alias ryujinx='flatpak run org.ryujinx.Ryujinx'
# alias yuzu='~/.scripts/yuzu.sh && ~/.appimages/yuzu.AppImage' # Comentado pois duplicado abaixo
alias yuzu='flatpak run org.yuzu_emu.yuzu'

# Multimídia
alias spotify='flatpak run com.spotify.Client'
alias stremio='flatpak run com.stremio.Stremio'

# Comunicação
# alias discord='flatpak run dev.vencord.Vesktop' # Comentado para usar o oficial abaixo (mude se preferir Vesktop)
alias discord='flatpak run com.discordapp.Discord'
alias telegram='flatpak run org.telegram.desktop'
alias thunderbird='flatpak run org.mozilla.Thunderbird'

# Produtividade / Outros
alias anki='flatpak run net.ankiweb.Anki'
alias calibre='flatpak run com.calibre_ebook.calibre'
alias trilium='flatpak run com.github.zadam.trilium'
alias logisim='java -jar ~/.appimages/logisim.jar'
alias firefox='flatpak run org.mozilla.firefox'

# Obsidian (AppImage com Wayland Flags)
alias obsidian='~/AppImages/obsidian.appimage --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime'
alias obsi='obsidian' # Reutiliza o alias acima para não repetir código
# ==========================================
# 7. SESSÕES HYPRLAND (Com EnvyControl Integrado & Blindado)
# ==========================================

function _hypr_launcher() {
    local TARGET_ALIAS="$1"
    local ENVY_MODE=""
    
    # 1. Mapeia o alias para o modo do EnvyControl
    case "$TARGET_ALIAS" in
        "mobile") ENVY_MODE="integrated" ;;  # Desliga Nvidia
        "home")   ENVY_MODE="hybrid" ;;      # Híbrido (Padrão)
        "nvidia") ENVY_MODE="nvidia" ;;      # Nvidia Pura
        *)        ENVY_MODE="hybrid" ;;
    esac

    # 2. Verifica o estado atual (com trim para garantir string limpa)
    local CURRENT_MODE
    CURRENT_MODE=$(envycontrol --query | xargs)

    echo -e "🔍 Estado Atual: \033[1;33m$CURRENT_MODE\033[0m | Meta: \033[1;34m$ENVY_MODE\033[0m"

    # 3. Se o modo estiver diferente, troca!
    if [ "$CURRENT_MODE" != "$ENVY_MODE" ]; then
        echo -e "\033[1;31m⚠️  Modo de GPU incorreto. Trocando hardware para '$ENVY_MODE'...\033[0m"
        
        # Executa o EnvyControl
        sudo envycontrol -s "$ENVY_MODE"
        
        echo -e "\n\033[1;32m✅ Troca realizada!\033[0m"
        echo -e "O EnvyControl recomenda reiniciar para aplicar as mudanças no Kernel."
        echo -e "Pressione [ENTER] para REINICIAR agora ou [CTRL+C] para cancelar."
        read -r
        sudo reboot
        return 0 # Para a execução aqui se o usuário cancelar mas não reiniciar
    fi

    # 4. Configuração das Variáveis do Hyprland
    
    # Busca dinâmica (Silenciosa se não encontrar a placa)
    local INTEL_RAW=""
    local NVIDIA_RAW=""
    local candidate=""

    for candidate in /dev/dri/by-path/*pci-0000:00:02.0-card; do
        [ -e "$candidate" ] || continue
        INTEL_RAW="$candidate"
        break
    done

    for candidate in /dev/dri/by-path/*pci-0000:01:00.0-card; do
        [ -e "$candidate" ] || continue
        NVIDIA_RAW="$candidate"
        break
    done

    # Resolve links simbólicos APENAS se o arquivo raw foi encontrado
    local INTEL_PATH=""
    local NVIDIA_PATH=""
    
    [ -n "$INTEL_RAW" ] && INTEL_PATH=$(readlink -f "$INTEL_RAW")
    [ -n "$NVIDIA_RAW" ] && NVIDIA_PATH=$(readlink -f "$NVIDIA_RAW")

    # Fallbacks de segurança (Só usa se as variáveis estiverem vazias E o arquivo existir)
    if [ -z "$INTEL_PATH" ] && [ -e "/dev/dri/card0" ]; then INTEL_PATH="/dev/dri/card0"; fi
    # Nota: Não forçamos fallback da Nvidia se ela não foi detectada, pois pode estar desligada.

    # 5. Exporta variáveis baseado no modo e na disponibilidade real
    if [ "$TARGET_ALIAS" == "mobile" ]; then
        echo -e "\033[1;34m🔋 [MOBILE] Iniciando Hyprland (Apenas Intel)...\033[0m"
        # Garante que só usa Intel, mesmo que Nvidia esteja ligada
        export AQ_DRM_DEVICES="$INTEL_PATH"
        export WLR_DRM_DEVICES="$INTEL_PATH"
        
    elif [ "$TARGET_ALIAS" == "nvidia" ]; then
        echo -e "\033[1;31m🔥 [NVIDIA] Iniciando Hyprland (Foco em Performance)...\033[0m"
        if [ -n "$NVIDIA_PATH" ]; then
             export AQ_DRM_DEVICES="$NVIDIA_PATH:$INTEL_PATH"
             export WLR_DRM_DEVICES="$NVIDIA_PATH:$INTEL_PATH"
        else
             echo -e "\033[1;31m❌ ERRO: Placa Nvidia não detectada!\033[0m"
             export AQ_DRM_DEVICES="$INTEL_PATH" # Fallback seguro
             export WLR_DRM_DEVICES="$INTEL_PATH"
        fi

    else
        echo -e "\033[1;32m🖥️  [HOME] Iniciando Hyprland Híbrido (Intel + HDMI)...\033[0m"
        # Só adiciona a Nvidia na lista se ela realmente existir
        if [ -n "$NVIDIA_PATH" ]; then
            export AQ_DRM_DEVICES="$INTEL_PATH:$NVIDIA_PATH"
            export WLR_DRM_DEVICES="$INTEL_PATH:$NVIDIA_PATH"
        else
            export AQ_DRM_DEVICES="$INTEL_PATH"
            export WLR_DRM_DEVICES="$INTEL_PATH"
        fi
    fi

    # Inicia o Hyprland
    exec Hyprland
}

# Aliases para os Modos do Hyprland
alias hypr-home='_hypr_launcher home'
alias hypr-mobile='_hypr_launcher mobile'
alias hypr-nvidia='_hypr_launcher nvidia'

# Exibir cheatsheet do Tmux se estiver dentro de uma sessão Tmux
if [ -n "$TMUX" ]; then
    "$HOME/.tmux_cheatsheet.sh"
fi
