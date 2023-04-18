"
" NeoVim configuration
"
"    ,;;,.        ::.
"  ,:::;,,.       :ccc,
"  ::c::,,,,.     :cccc 
"  cccc:;;;;;.    cllll 
"  cccc;';;;;;,   cllll 
"  ccccc  :;;;;;. coooo 
"  lllll   ':::::.loooo 
"  lllll    ':::::loooo 
"  ooooo      ::::llodd 
"  'oooo       :cclooo: 
"   `:oc        'coo;:´
"     `´         `''´  

" Exit terminal mode with escape instead of the stupid standard
tnoremap <Esc> <C-\><C-n>
set nofoldenable " Don't fold everything in new files
windo set scrolloff=1
filetype plugin on
set number

" vim-plug is a vim plugin manager
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
"Plug 'kyazdani42/nvim-tree.lua'
Plug 'airblade/vim-rooter'
Plug 'tmhedberg/SimpylFold'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'
"Plug 'mhinz/vim-startify'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-fugitive'
call plug#end()

set noshowmode

" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"let g:ale_linters = {'python': ['pylint']}
" \   'bandit',
" \   'jedils',
" \   'mypy',
" \   'prospector',
" \   'pycodestyle',
" \   'pydocstyle',
" \   'pyflakes',
" \   'pylama',
" \   'pylint',
" \   'pylsp',
" \   'pyre',
" \   'pyright',
" \   'vulture'

" colorscheme
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

fu! CustomFoldText(string)
    " get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif
    let pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " remove leading comments from line
    let line = substitute(line, '^\s*'.pat.'\s*', '', '')
    " remove foldmarker from line
    let pat  = '\%('. pat. '\)\?\s*'. split(&l:fmr, ',')[0]. '\s*\d\+'
    let line = substitute(line, pat, '', '')

"   let line = substitute(line, matchstr(&l:cms,
"	    \ '^.\{-}\ze%s').'\?\s*'. split(&l:fmr,',')[0].'\s*\d\+', '', '')

    if get(g:, 'custom_foldtext_max_width', 0)
	let w = g:custom_foldtext_max_width - &foldcolumn - (&number ? 8 : 0)
    else
	let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    endif
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = '+'. v:folddashes
    let lineCount = line("$")
    if exists("*strwdith")
	let expansionString = repeat(a:string, w - strwidth(foldSizeStr.line.foldLevelStr))
    else
	let expansionString = repeat(a:string, w - strlen(substitute(foldSizeStr.line.foldLevelStr, ' ', 'x', 'g')))
    endif
    return line . expansionString . foldSizeStr . foldLevelStr
endf

augroup terminal_settings
    autocmd!

    " autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Ignore fzf, ranger, coc
    autocmd TermClose term://*
      \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
      \   call nvim_input('<CR>')  |
      \ endif
augroup END

set foldtext=CustomFoldText('\ ')

let g:rooter_patterns = ['Session.vim']
let g:startify_custom_header = [
		\ '    _   _         __     ___           ',
		\ '   | \ | | ___  __\ \   / (_)_ __ ____ ',
		\ '   |  \| |/ _ \/ _ \ \ / /| | `_ ` _  \',
		\ '   | |\  |  __/ (_) \ V / | | | | | | |',
		\ '   |_| \_|\___|\___/ \_/  |_|_| |_| |_|',
		\]
let g:startify_bookmarks = ['~/.config/nvim/init.vim']
let g:startify_lists = [
			\ {'type': 'sessions',  'header': ['   Sessions']},
			\ {'type': 'bookmarks', 'header': ['   Bookmarks']}]

" Run file in terminal window
nnoremap <F5> :vsplit <bar> :term python ~/Programmering/vim-run-py.py % <CR>
" inoremap <silent> <F5> <Esc> :execute ':vsplit <bar> :term python "~/Programmering/vim-run-py.py %"' <bar> :startinsert <CR> a

" Save
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>a
" Bruh

" Better window navigation
noremap  <A-h> <C-w>h
noremap! <A-h> <C-w>h
tnoremap <A-h> <C-w>h
noremap  <A-j> <C-w>j 
noremap! <A-j> <C-w>j
tnoremap <A-j> <C-w>j
noremap  <A-k> <C-w>k
noremap! <A-k> <C-w>k
tnoremap <A-k> <C-w>k
noremap  <A-l> <C-w>l
noremap! <A-l> <C-w>l
tnoremap <A-l> <C-w>l

nnoremap <A-q> :q<CR>
inoremap <A-q> <Esc> :q<CR>
tnoremap <A-q> <Esc> :q<CR>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
nnoremap + $
tnoremap + $

nnoremap <Tab> :tabnext<CR>
" nnoremap <S-Tab> :tabprevious<CR>

" CoCk
" use <tab> for trigger completion and navigate to the next complete item
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <C-Space>
"       \ pumvisible() ? "\<C-Space>" :
"       \ <SID>check_back_space() ? "\<C-Space>" :
"       \ coc#refresh()

" "inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <silent><expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

nnoremap <C-Space> viws

