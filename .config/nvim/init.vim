" Load plugins
" Auto-install vim-plug
if empty(glob($HOME.'/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin($HOME.'/.config/nvim/autoload/plugged')

    " File Explorer and git wrapper
    Plug 'scrooloose/NERDTree' |
        \ Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tpope/vim-fugitive'
    " Auto pairs for '(' '[' '{' and surroundings
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    " Easy repeats with .
    Plug 'tpope/vim-repeat'
    " Language server, syntax highlighting and testing
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot'
    Plug 'janko-m/vim-test'
    " Indentation lines
    Plug 'Yggdroot/indentLine'
    " Distraction-free mode
    Plug 'junegunn/goyo.vim'
    " Theme, icons  and status bar
    Plug 'arcticicestudio/nord-vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'itchyny/lightline.vim'
    call plug#end()

" Editor functions performing a full plugin installation & upgrade
function! FullPluginInstall()
    " Install vim-plug extensions
    PlugInstall
    " Install the coc extensions listed in package.json
    !cd $HOME/.config/coc/extensions; npm install;
endfunction

function! FullPluginUpgrade() 
    " Update vim-plug extensions
    PlugUpdate
    PlugUpgrade
    " Update Coc Extensions
    CocUpdate
endfunction

command! -nargs=0 Install :call FullPluginInstall()
command! -nargs=0 Upgrade :call FullPluginUpgrade()

" Map the leader key to ','
let mapleader=','
"Switch between splits using hjkl
nnoremap <C-j> <C-w>j 
nnoremap <C-k> <C-w>k 
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
" Use the leader key to delete insted of cut 
nnoremap <leader>x "_x
nnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>d "_d

" Basic settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set number
set cursorline
set laststatus=2
set numberwidth=1
set title
set titlestring=Neovim:\ %-25.55F\ %a%r%m titlelen=70
set noshowmode
set nowrap
set splitbelow
set splitright
set hidden
set autowrite
set scrolloff=6
set encoding=utf-8
set sidescrolloff=6
set backupdir=$HOME/.cache/nvim/backup
set dir=$HOME/.cache/nvim
set nobackup
set nowritebackup
autocmd VimEnter * if &diff | cmap q qa| endif
let g:python3_host_prog = '/usr/bin/python3'

" Nord theme
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

" Coc Settings
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Code navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation with K
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Editor commands for formatting, folding and imports
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>n

" Polyglot
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

"Get diagnostics string for lightline
function! StatusDiagnostic() abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
        call add(msgs, ' ' . info['error'])
    endif
    if get(info, 'warning', 0)
        call add(msgs, ' ' . info['warning'])
    endif
    if get(info, 'information', 0)
        call add(msgs, ' ' . info['information'])
    endif
    if get(info, 'hint', 0)
        call add(msgs, ' ' . info['hint'])
    endif
    return join(msgs, ' ')
endfunction

"Lightline status bar configuration
let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \       'left': [ [ 'mode', 'paste' ],
        \                 [ 'readonly', 'filename', 'modified'] ],
        \       'right': [ [ 'cocstatus', 'gitbranch', 'filetype', 'lineinfo'] ]
        \ },
        \ 'inactive': {
        \       'right': [ [ 'filetype', 'lineinfo'] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'FugitiveHead',
        \   'cocstatus': 'StatusDiagnostic',
        \ },
        \ }

"Indentline configuration
let g:indentLine_color_term = 0
let g:indentLine_char = '|'

" Clipboard provider
let g:clipboard = {
  \   'name': 'xclip',
  \   'copy': {
  \      '+': 'xclip -selection clipboard',
  \      '*': 'xclip -selection clipboard',
  \    },
  \   'paste': {
  \      '+': 'xclip -selection clipboard -o',
  \      '*': 'xclip -selection clipboard -o',
  \   },
  \   'cache_enabled': 1,
  \ }
set clipboard+=unnamedplus

" NERDtree 
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" Close when there is only nerdtree open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Avoid problems with vim-plug opening the window on a nerdtree
let g:plug_window = 'noautocmd vertical topleft new'
" Change the UI of the tree
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
map <C-n> :NERDTreeToggle<CR>
" Fix borked colors
autocmd BufEnter * highlight! link NERDTreeFlags NERDTreeDir
" Set bookmark file
let g:NERDTreeBookmarksFile=$HOME."/.config/nvim/NERDTreeBookmarks"
" Git status symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'*',
                \ 'Staged'    :'',
                \ 'Untracked' :'?',
                \ 'Renamed'   :'',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'',
                \ 'Dirty'     :'',
                \ 'Ignored'   :'',
                \ 'Clean'     :'',
                \ 'Unknown'   :'',
                \ }

" .txt file formatting
function TxtFormat()
    " Spellfile in the main file's dir
    let &spellfile=expand('%:p:h').'/pl.add'
    setlocal spelllang=pl,en_us
    setlocal spell
    setlocal spellsuggest+=5
    iabbrev <buffer> -- —
    " Disable all automatic indentation
    setlocal noautoindent
    setlocal nobreakindent
    setlocal nosmartindent
    setlocal nocindent
    setlocal noexpandtab
    " Soft line wrap
    setlocal wrap linebreak
    setlocal scrolloff=1
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
    " Make the window distraction-free
    setlocal conceallevel=0
    setlocal nocursorline
    if !&diff && !exists('#goyo')
        call lightline#init() " Without this there will be errors
        Goyo
        cmap q qa
    endif
endfunction

autocmd BufEnter,VimEnter *.txt call TxtFormat()
" Resize goyo automatically after resizing vim
autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
