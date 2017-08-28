" Visible quotations in json file
let g:vim_json_syntax_conceal=0

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
set clipboard=unnamedplus

" syntax hilight config
syntax on

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
set runtimepath^=~/.vim/bundles/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.vim/bundles'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/neocomplete')
call dein#add('scrooloose/syntastic')
call dein#add('rizzatti/dash.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('leafgarland/typescript-vim')
call dein#add('fatih/vim-go')
call dein#add('Quramy/vim-js-pretty-template')
call dein#add('Quramy/tsuquyomi')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('magarcia/vim-angular2-snippets')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('digitaltoad/vim-pug')
call dein#add('Yggdroot/indentLine')
call dein#add('majutsushi/tagbar')
call dein#add('tpope/vim-fugitive')
call dein#add('maksimr/vim-jsbeautify')
call dein#add('elzr/vim-json')
call dein#add('lumiliet/vim-twig')
call dein#add('jwalton512/vim-blade')
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

" NERD Tree configure-------------------------
" Show hidden file(i.e. dotfiles)
let NERDTreeShowHidden=1

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
