set dir=$HOME/.vim_tmp/swap
if !isdirectory(&dir) | call mkdir(&dir, 'p', 0700) | endif

" Visible quotations in json file
let g:vim_json_syntax_conceal=0

" encoding conig
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,sjis,utf-16le,utf-16,euc-jp

set autoindent

" show numbers of line
set number
highlight LineNr ctermfg=210

" using visual beep
set visualbell

" make possible deleting start of line, eol and indent by backspace key
set backspace=start,eol,indent

" save to clipboard when yunk
set clipboard^=unnamed,unnamedplus

" syntax hilight config
syntax on

" highlight variable under cursor
" autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" Choose end of line by two 'v'
vnoremap v $h


""" Aliases in normal mode
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <silent><C-i> :Dash<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-m> :cN<CR>
nnoremap <F8> :TagbarToggle<CR>

""" Aliases in insert mode
"inoremap uu <Esc>
"inoremap jj <Esc> 
inoremap <C-j> <C-x><C-o>

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
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " The Neosnippet plug-In adds snippet support to Vim.
  " https://github.com/Shougo/neosnippet.vim
  call dein#add('Shougo/neosnippet.vim')

  " The standard snippets repository for neosnippet 
  call dein#add('Shougo/neosnippet-snippets')

  " Next generation completion framework after neocomplcache
  " https://github.com/Shougo/neocomplete.vim
  call dein#add('Shougo/neocomplete')

  " A tree explorer plugin for vim. 
  " https://github.com/preservim/nerdtree
  call dein#add('scrooloose/nerdtree')

  " emmet for vim: http://emmet.io/
  " https://github.com/mattn/emmet-vim
  call dein#add('mattn/emmet-vim')

  " Go development plugin for Vim 
  " https://github.com/fatih/vim-go
  call dein#add('fatih/vim-go')

  " Interactive command execution in Vim.
  " https://github.com/Shougo/vimproc.vim
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

  " EditorConfig plugin for Vim
  " https://github.com/editorconfig/editorconfig-vim
  call dein#add('editorconfig/editorconfig-vim')

  " A vim plugin to display the indention levels with thin vertical lines
  " https://github.com/Yggdroot/indentLine
  call dein#add('Yggdroot/indentLine')

  " fugitive.vim: A Git wrapper so awesome, it should be illegal 
  " https://github.com/tpope/vim-fugitive
  call dein#add('tpope/vim-fugitive')

  " Vastly improved Javascript indentation and syntax support in Vim. 
  " https://github.com/pangloss/vim-javascript
  call dein#add('pangloss/vim-javascript')

  " CSS3 syntax (and syntax defined in some foreign specifications) support for Vim's built-in syntax/css.vim 
  " https://github.com/hail2u/vim-css3-syntax
  call dein#add('hail2u/vim-css3-syntax')

  " Syntax checking hacks for vim 
  " https://github.com/vim-syntastic/syntastic
  call dein#add('vim-syntastic/syntastic')

  " Use RipGrep in Vim and display results in a quickfix list 
  " https://github.com/jremmen/vim-ripgrep
  call dein#add('jremmen/vim-ripgrep')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

" NERD Tree configure-------------------------
" Show hidden file(i.e. dotfiles)
let NERDTreeShowHidden=1
function NERDTreeWinSize(arg)
  let g:NERDTreeWinSize=a:arg
endfunction
command! -nargs=* Ntws call NERDTreeWinSize( '<args>' ) | NERDTree

" End of NERD Tree configure -------------------------

" go-vim configure--------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/
" End of go-vim configure-------------------- 

" Javascript -------------------------
map <c-f> :call JsBeautify()<cr>
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for php
autocmd FileType php noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END

" syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:rg_command = 'rg --vimgrep -S'
