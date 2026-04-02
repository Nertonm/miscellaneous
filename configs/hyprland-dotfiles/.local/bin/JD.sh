#!/bin/bash

# ==============================================================================
# SCRIPT DE SETUP: JD-HYBRID FILESYSTEM
# ==============================================================================
# Uso: ./setup_structure.sh [caminho_opcional]
# Exemplo: ./setup_structure.sh ~/MeusArquivos
# Se nenhum caminho for passado, cria em ~/JD_System
# ==============================================================================

# --- Configurações de Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Definição do Diretório Raiz ---
# Usa o primeiro argumento como diretório, ou define o padrão
ROOT_DIR="${1:-$HOME/JD_System}"

echo -e "${BLUE}>>> Iniciando setup da arquitetura Johnny.Decimal Híbrida...${NC}"
echo -e "${BLUE}>>> Diretório Alvo: ${YELLOW}$ROOT_DIR${NC}\n"

# --- A Taxonomia Mestra ---
# Lista de diretórios baseada na lógica 10-99
declare -a FOLDERS=(
    # 00-09: Admin & Inbox
    "00_Inbox"
    "01_Desktop_Dump"
    "09_System_Config"

    # 10-19: Pessoal (Life)
    "11_Identity"
    "12_Finance"
    "13_Health"
    "14_Housing"

    # 20-29: Profissional
    "21_Career"
    "22_Contracts"
    "23_Freelance"

    # 30-49: Desenvolvimento (DevOps & Code)
    "30_Github_Repos"
    "31_Playground"
    "32_Snippets"
    "35_Assets_Dev"
    "38_Docs_Reference"
    "40_Docker_Data"

    # 50-59: Mídia & Assets
    "51_Photos_Raw"
    "52_Design_Assets"
    "55_Video_Projects"
    "58_Audio_Library"

    # 60-69: Sistema & Homelab
    "61_ISOs"
    "62_VM_Disks"
    "63_Drivers_Firmware"
    "64_Backups_Devices"
    "65_Software_Tools"

    # 90-99: Arquivo Morto
    "90_Archive_Legacy"
    "99_Trash_Holding"
)

# --- Execução ---

# 1. Cria a pasta raiz se não existir
if [ ! -d "$ROOT_DIR" ]; then
    mkdir -p "$ROOT_DIR"
    echo -e "${GREEN}[CRIADO]${NC} Raiz do sistema: $ROOT_DIR"
else
    echo -e "${YELLOW}[EXISTE]${NC} Raiz do sistema já existe."
fi

# 2. Loop de criação das pastas
for folder in "${FOLDERS[@]}"; do
    TARGET_PATH="$ROOT_DIR/$folder"

    if [ ! -d "$TARGET_PATH" ]; then
        mkdir -p "$TARGET_PATH"
        echo -e "${GREEN}  + Criado:${NC} $folder"
    else
        echo -e "${YELLOW}  . Pulado (Já existe):${NC} $folder"
    fi
done

# 3. Gera um README.md com a legenda (Documentação como Código)
README_FILE="$ROOT_DIR/README_TAXONOMY.md"
if [ ! -f "$README_FILE" ]; then
    echo -e "\n${BLUE}>>> Gerando documentação indexada...${NC}"
    cat <<EOF > "$README_FILE"
# 🗂 Estrutura de Arquivos - JD Híbrido

## 00-09: ADMIN
00_Inbox          -> Entrada de tudo. Esvaziar semanalmente.
01_Desktop_Dump   -> Limpeza rápida da área de trabalho.
09_System_Config  -> Dotfiles, chaves SSH, configs globais.

## 10-19: PESSOAL
11_Identity       -> RG, CPF, Passaporte.
12_Finance        -> IR, Boletos, Comprovantes.
13_Health         -> Exames e Vacinas.
14_Housing        -> Contas de casa e Aluguel.

## 20-29: PROFISSIONAL
21_Career         -> CVs, Diplomas.
22_Contracts      -> Contratos de trabalho.
23_Freelance      -> Projetos e Notas Fiscais.

## 30-49: DEV & DEVOPS
30_Github_Repos   -> Clones git (user/repo).
31_Playground     -> Testes descartáveis.
32_Snippets       -> Gists locais.
40_Docker_Data    -> Volumes persistentes.

## 50-59: MEDIA
51_Photos_Raw     -> Backup de Câmera/Celular.
55_Video_Projects -> Edição e OBS.

## 60-69: SYSTEM
61_ISOs           -> Imagens de Instalação.
62_VM_Disks       -> Discos QCOW2/VDI.
65_Software_Tools -> AppImages e Portables.

## 90-99: ARCHIVE
90_Archive_Legacy -> Projetos antigos (Cold Storage).
99_Trash_Holding  -> Lixeira pré-deleção permanente.
EOF
    echo -e "${GREEN}[CRIADO]${NC} Arquivo de legenda: README_TAXONOMY.md"
fi

echo -e "\n${GREEN}>>> Processo finalizado com sucesso!${NC}"
echo -e "Acesse seu novo sistema: cd $ROOT_DIR"
