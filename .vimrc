set dir=$HOME/.vim_tmp/swap
if !isdirectory(&dir) | call mkdir(&dir, 'p', 0700) | endif

" Visible quotations in json file
let g:vim_json_syntax_conceal=0
let g:indentLine_setConceal = 0

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


" Required:
filetype plugin indent on
syntax enable


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


augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END

" syntastic config
set statusline^=%{coc#status()})}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:rg_command = 'rg --vimgrep -S'
