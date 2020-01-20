colorscheme delek
highlight clear CursorLine

set tabstop=4
" Do not expand tabs for Makefiles
autocmd FileType make setlocal noexpandtab
syntax on
set expandtab
set number
set nocp
" On some systems the highlithing of the cursorline does not seem to work; so it is disabled
"set cursorline
set wildmenu
highlight CursorLine term=bold cterm=bold guibg=NONE
highlight CursorLineNr ctermbg=236 ctermfg=white

" Highlight whitespace at the end of the line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Highlight search and disable highlighting after pressing `i`
set hlsearch
set incsearch
nnoremap i :noh<cr>i


