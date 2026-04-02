" -----------------------------------------------------------------------------
" GERAL
" -----------------------------------------------------------------------------
    set encoding=utf-8             " Define a codificação de caracteres para UTF-8
    set number                     " Exibe os números das linhas
    set relativenumber             " Exibe números relativos das linhas
    " Para integração de mouse em todos os modos
    set mouse=a                 " Ativa o uso do mouse em todos os modos (comentado)
    set hidden                     " Permite mudar de buffers sem salvar as alterações
    set wrap                       " Habilita a quebra automática de linha (linha continua se necessário)
    set incsearch                  " Destaca as correspondências de busca enquanto digita
    set ignorecase                 " Ignora diferenças entre maiúsculas e minúsculas nas buscas
    set hlsearch                   " Destaca as correspondências de busca com cores diferentes
    set showmatch                  " Destaca parênteses ou colchetes correspondentes
    set title                      " Exibe o nome do arquivo na barra de título da janela
    set backspace=indent,eol,start  " Permite apagar indentação, final de linha e até o início ao pressionar Backspace
    set confirm                    " Pergunta antes de realizar ações que possam causar perda de dados
    set splitbelow                 " Ao dividir a janela, a nova janela aparece abaixo
    set splitright                 " Ao dividir a janela, a nova janela aparece à direita
    set fillchars=vert:│,fold:-,eob:~,lastline:@  " Personaliza os caracteres para divisões verticais, dobras e áreas de final de buffer
    set path=.,**                  " Permite busca recursiva de arquivos com :find
    set clipboard+=unnamedplus     " Usa o sistema de clipboard do sistema operacional para copiar e colar
    syntax on                      " Ativa o destaque de sintaxe
    syntax enable                  " Habilita o destaque de sintaxe para os arquivos

    " -----------------------------------------------------------------------------
    set noerrorbells         " Desativa sons ou avisos visuais ao errar comandos
    " -----------------------------------------------------------------------------

    " Tabulações
    set expandtab            " Converte o caractere Tab em espaços
    set tabstop=4            " Define a largura de um Tab como 4 espaços
    set softtabstop=4        " Controla quantos espaços são inseridos ao pressionar Tab
    set shiftwidth=4         " Define quantos espaços são usados ao fazer indentação automática
    " -----------------------------------------------------------------------------

    " Ortografia e auto completar
    "set spell               " (opcional) Ativa correção ortográfica
    set spelllang=pt,en      " Define os idiomas usados no corretor ortográfico
    set complete+=kspell     " Usa palavras corretas da linguagem no autocompletar
    set completeopt=menuone,longest " Mostra menu e completa até a palavra mais longa
    set shortmess+=c         " Reduz mensagens no menu de autocompletar
    " -----------------------------------------------------------------------------

    set path=.,**            " Permite busca recursiva de arquivos com :find
    set nobackup             " Desativa criação de arquivos de backup
    set undodir=~/.vim/undodir " Define o diretório onde o histórico de undo será salvo
    set undofile             " Permite manter histórico de undo entre sessões
    set cursorline           " Destaca a linha atual do cursor
    set hidden               " Permite mudar de buffer sem salvar o atual
    " -----------------------------------------------------------------------------

    " Menu de comandos (autocompletar no modo comando)
    set wildmenu             " Ativa menu visual para completar comandos
    set wildmode=longest,full " Mostra sugestão mais longa e todas opções
    set wildoptions=pum      " Exibe menu como pop-up (estilo moderno)
    " -----------------------------------------------------------------------------

    " Busca
    set hls                  " Ativa realce dos resultados de busca
    set is                   " Ativa busca incremental (realça conforme digita)
    " -----------------------------------------------------------------------------

    set noshowmode           " Oculta modo (útil quando se usa statusline personalizada)
    set laststatus=2         " Sempre mostra a barra de status na parte inferior
    colorscheme habamax      " Define o esquema de cores do Vim
    " -----------------------------------------------------------------------------

    :set foldmethod=marker   " Usa marcadores {{{ }}} para criar dobras de código

    " -----------------------------------------------------------------------------


" -----------------------------------------------------------------------------
" GERENCIAMENTO DE ABAS E TERMINAL
" -----------------------------------------------------------------------------
    let mapleader="'"

    " Cria uma nova aba com <leader>n
    nnoremap <leader>n :tabnew<CR>

    " Navegar entre abas com <leader>h (aba anterior) e <leader>l (próxima aba)
    nnoremap <leader>h :tabprevious<CR>
    nnoremap <leader>l :tabnext<CR>

    " Cria um terminal na aba atual com <leader>t
    nnoremap <leader>t :vsplit \| terminal<CR>

    " Retorna ao modo normal no terminal com Esc
    tnoremap <Esc> <C-\><C-n>


" -----------------------------------------------------------------------------
" NAVEGAÇÃO E EDIÇÃO
" -----------------------------------------------------------------------------
    " Mapeia <leader>k para corrigir automaticamente a palavra em curso
    nnoremap <Leader>k :normal! z=<CR>

    " Abre o explorador de arquivos com <C-E>
    nnoremap <C-E> :Lex<CR>

    " Mapeia F2 para ativar/desativar a correção ortográfica
    map <f2> :set spell!<cr>

    " Mapeia <leader>h para ir para a aba da esquerda
    nnoremap <leader>h :tabprevious<CR>

    " Mapeia <leader>l para ir para a aba da direita
    nnoremap <leader>l :tabnext<CR>

" -----------------------------------------------------------------------------
" MAPEAMENTOS E AÇÕES RÁPIDAS
" -----------------------------------------------------------------------------
    " Copia o conteúdo selecionado para a área de transferência com <C-y> (modo visual)
    xnoremap <silent> <C-y> :w !wl-copy<CR><CR>

    " Insere marcas de dobra com <leader>zz
    map <leader>zz :.!~/.vim/scripts/foldmark

    cnoremap sudow !sudo tee % >/dev/null

" -----------------------------------------------------------------------------
" Gerenciamento de Telas Divididas
" -----------------------------------------------------------------------------
" Redimensionar telas com atalhos
    nnoremap <leader>= :resize +5<CR>  " Aumenta a altura da janela ativa
    nnoremap <leader>- :resize -5<CR>  " Diminui a altura da janela ativa
    nnoremap <leader>, :vertical resize +5<CR>  " Aumenta a largura da janela ativa
    nnoremap <leader>. :vertical resize -5<CR>  " Diminui a largura da janela ativa

    " Movimentar entre as telas divididas
    nnoremap <leader>w <C-w>w  " Move entre as janelas divididas
    nnoremap <leader>h <C-w>h  " Move para a janela à esquerda
    nnoremap <leader>j <C-w>j  " Move para a janela abaixo
    nnoremap <leader>k <C-w>k  " Move para a janela acima
    nnoremap <leader>l <C-w>l  " Move para a janela à direita

" -----------------------------------------------------------------------------
" Definir as cores e o estilo do statusline
" -----------------------------------------------------------------------------
    hi statusline gui=bold guibg=#98C379 guifg=#101120
    hi statuslinenc gui=NONE cterm=NONE guibg=#3E4452 guifg=#B0B1C0
    hi StatusLineMode gui=bold guibg=#C678DD guifg=#282C34
    hi StatusLineGitBranch gui=bold guifg=#61AFEF

" -----------------------------------------------------------------------------
" Definir as cores de acordo com o modo de operação
" -----------------------------------------------------------------------------
    augroup ModeEvents
        autocmd!
        " Quando entra no modo de inserção
        au InsertEnter * hi statusline guibg=#61AFEF
        " Quando sai do modo de inserção
        au InsertLeavePre * hi statusline guibg=#98C379
        " Quando entra em modos visuais (v, V, ou bloco)
        au ModeChanged *:[vV\x16]* hi statusline guibg=#C678DD
        au ModeChanged [vV\x16]*:* hi statusline guibg=#98C379
        " Quando entra no modo de substituição
        au ModeChanged *:[R]* hi statusline guibg=#EB6E6E
        au ModeChanged [R]* hi statusline guibg=#98C379
    augroup end


" -----------------------------------------------------------------------------
" Git Info
" -----------------------------------------------------------------------------
    function! GitBranch()
    let l:branch = systemlist('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    return empty(l:branch) ? '' : l:branch[0]
    endfunction

    function! GitUncommitted()
    if !empty(GitBranch())
        let l:changes = systemlist('git status --porcelain 2>/dev/null')
        return !empty(l:changes) ? '*' : ''
    endif
    return ''
    endfunction

    function! GitStatus()
    let l:branch = GitBranch()
    if empty(l:branch)
        return ''
    endif
    return '│ Git:' . l:branch . GitUncommitted() . ' '
    endfunction

" -----------------------------------------------------------------------------
" Função que define o conteúdo da statusline
" -----------------------------------------------------------------------------
    function! CurrentMode()
        let modes = {
            \ 'n': 'NORMAL',
            \ 'no': 'N-PENDING',
            \ 'v': 'VISUAL',
            \ 'V': 'V-LINE',
            \ "\<C-v>": 'V-BLOCK',
            \ 's': 'SELECT',
            \ 'S': 'S-LINE',
            \ "\<C-s>": 'S-BLOCK',
            \ 'i': 'INSERT',
            \ 'R': 'REPLACE',
            \ 'Rv': 'V-REPLACE',
            \ 'c': 'COMMAND',
            \ 'cv': 'EX',
            \ 'ce': 'EX',
            \ 'r': 'PROMPT',
            \ 'rm': 'MORE',
            \ 'r?': 'CONFIRM',
            \ '!': 'SHELL',
            \ 't': 'TERMINAL'
        \ }
        let l:raw_mode = mode()
        return has_key(modes, l:raw_mode) ? modes[l:raw_mode] : toupper(l:raw_mode)
    endfunction

    function! ActiveStatusLine()
        let l:mode = '%0* %{CurrentMode()} '
        let l:filename = '%1*│ [%n] %t%{&modified ? " +" : ""} '
        let l:git = '%{GitStatus()}'
        let l:fileinfo = '│ %{&ff} | %{&fenc != "" ? &fenc : &enc} | %{&filetype != "" ? tolower(&filetype) : "no ft"} '
        let l:position = '%#StatusLine#%p%% │ %l:%c%* '
        let l:clock = '%1*│ ' . strftime('%H:%M:%S') . ' '

        let &statusline = l:mode . l:filename . l:git . l:fileinfo . l:position . l:clock
    endfunction

    call ActiveStatusLine()

" -----------------------------------------------------------------------------
" Cores adicionais
" -----------------------------------------------------------------------------
    hi StatusLineGitBranch guifg=#61afef guibg=#3e4452 gui=bold
    hi User1 gui=NONE cterm=NONE guifg=#b0b1c0 guibg=#3E4452
    hi User2 gui=NONE cterm=NONE guifg=#b0b1c0 guibg=#2C324D

    " Fundo transparente...
    hi Normal guibg=NONE ctermbg=NONE

    " Linha do cursor...
    hi CursorLine guibg=#202130

    " Linha de coluna...
    hi ColorColumn guibg=#202130

    " Comentários em itálico...
    hi Comment cterm=italic gui=italic

    " Divisão vertical de janelas...
    hi VertSplit ctermbg=NONE guibg=NONE ctermfg=7 guifg=#2c324d

    " Barra de abas...
    hi TabLine      guifg=#9192a0 guibg=#2c324d gui=none
    hi TabLineSel   guifg=#a1a2b0 guibg=NONE gui=bold
    hi TabLineFill  guifg=#9192a0 guibg=#2c324d gui=none

    " Seleção (modo visual)...
    hi Visual guifg=NONE guibg=#303140

    " Cores das dobras (folding)...

    hi Folded guibg=NONE guifg=#505160 gui=italic cterm=italic

    nmap <c-s>  :-1read ~/.vim/snippets/<c-z>

" -----------------------------------------------------------------------------
" Autocomandos
" -----------------------------------------------------------------------------
     autocmd BufWinLeave ?* mkview
     autocmd BufWinEnter ?* silent loadview

    " Redimensionar janelas quando terminal mudar de tamanho...
    autocmd vimresized * wincmd =

" -----------------------------------------------------------------------------
" Configurações de tabulação para diferentes linguagens
" -----------------------------------------------------------------------------
    " Para Python (usa 4 espaços)
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

    " Para JavaScript, TypeScript, e similares (4 espaços também)
    autocmd FileType javascript,typescript setlocal tabstop=4 shiftwidth=4 expandtab

    " Para C, C++, Java, etc (usa 4 espaços)
    autocmd FileType c,cpp,java setlocal tabstop=4 shiftwidth=4 expandtab

    " Para HTML, CSS (usa 2 espaços)
    autocmd FileType html,css setlocal tabstop=2 shiftwidth=2 expandtab

    " Para Go (tabulação com tab real, não espaços)
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

    " Para Ruby (usa 2 espaços)
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 expandtab

    " Para Lua (usa 2 espaços)
    autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab

    " Para Makefiles (usa tabulação real)
    autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8

    " Para Markdown (usa 2 espaços)
    autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab

    " Para SQL (usa 2 espaços)
    autocmd FileType sql setlocal tabstop=2 shiftwidth=2 expandtab

    " Para arquivos de configuração (ex: .vimrc, .bashrc)
    autocmd FileType vim,sh setlocal tabstop=4 shiftwidth=4 expandtab

    " Tabulações para arquivos ...
    autocmd filetype asm setlocal noexpandtab ts=8 sw=8 sts=8

    " Não expande tabulações em arquivos make...
    autocmd filetype make setlocal noexpandtab 


