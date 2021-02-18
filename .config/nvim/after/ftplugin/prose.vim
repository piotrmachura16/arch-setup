" PROSE FTPLUGIN
" --------------
setlocal noautoindent nobreakindent nosmartindent nocindent
setlocal shiftwidth=2 softtabstop=2
setlocal wrap linebreak scrolloff=0
setlocal nolist nonumber norelativenumber nocursorline
setlocal spell spelllang=pl,en_us spellsuggest+=5
let &l:spellfile=expand('%:p:h').'/.words/utf-8.add'
if !filereadable(expand('%:p:h').'/.words/utf-8.add.spl')
    mkspell!
endif
let g:indentLine_fileTypeExclude+=['prose']
inoreabbrev <buffer> -- ―
inoreabbrev <buffer> ... …<Left><Left><Del><Right>
noremap <buffer> j gj
noremap <buffer> k gk

function! s:fix_docx()
    %s/\.\.\./…/g
    %s/’/'/g
    %s/\n\n\n/\r\r/g
    %s/”\|„\|''\|,,/"/g
    %s/- \|– /― /g
endfunction

command! FixDocx call <SID>fix_docx()
