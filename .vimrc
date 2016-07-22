" encoding conig
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,shift_jis

" show numbers of line
set number
highlight LineNr ctermfg=210
" using visual beep
set visualbell

" make possible deleting start of line, eol and indent by backspace key
set backspace=start,eol,indent

" save to clipboard when yunk
set clipboard=unnamed

" syntax hilight config
syntax on

" Choose end of line by two 'v'
vnoremap v $h


""" Aliases in normal mode
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <silent><C-i> :Dash<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-m> :cN<CR>

""" Aliases in insert mode
inoremap uu <Esc>
inoremap jj <Esc> 


""" autocompletions
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o><TAB>
inoremap ( ()<Left>
inoremap (<Enter> ()<Left><CR><ESC><S-o><TAB>

" Delete previous character when by delete key
inoremap <silent> <C-h> <Del>

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.vim/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.vim'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('rizzatti/dash.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('leafgarland/typescript-vim')
" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

" indent config 
setlocal expandtab 
setlocal tabstop=2 shiftwidth=2 softtabstop=2 
setlocal autoindent

" NERD Tree configure-------------------------
" Show hidden file(i.e. dotfiles)
let NERDTreeShowHidden=1

" End of NERD Tree configure -------------------------
