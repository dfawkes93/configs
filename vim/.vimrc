" External plugins go here (vimplugged)
call plug#begin()
"   Syntax for adding extra plugins:
"   Plug 'user/repo' (github links)
    Plug 'vim-airline/vim-airline'
call plug#end()

" Function for finding file encoding and displaying it in airline
fun! SetTag()
    silent let w:filetag = ' ' . system("chtag -p " . expand('%:p') . " | cut -d ' ' -f 2 | tr '\n' ' '")
    let g:airline_section_y = w:filetag
endfun

" Autocmd to run SetTag on file open
augroup tagging
    autocmd!
    au BufReadPre, *.* call SetTag()
augroup END

" Autocmd to set color column on hlasm/jcl files
augroup colorcol
    autocmd!
    au BufReadPost *.hlasm,*.jcl set cc=72
augroup END

set smartindent
set tabstop=4 softtabstop=4
set number
set relativenumber
set shiftwidth=4
set expandtab
set nowrap
set noswapfile
set showcmd
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set smartcase
set path+=** 
set nocompatible

set encoding=utf-8

" Enable syntax highlighting
syntax enable
filetype plugin on

"Visual settings
set background=dark
highlight OverLength ctermbg=red ctermfg=white guibg=#592929 
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

"Airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dark'
let g:airline#extensions#tabline#buffer_idx_mode = 1

" Map space as leader key
let mapleader=" "
let maplocalleader=" "
nnoremap <SPACE> <Nop>

" Ctrl + hjkl for window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Cursor display (block for normal mode, bar for insert)
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Keymap <leader>n to open buffer n
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
" Formatting for Tab indexes
  let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '[0] ',
        \ '1': '[1] ',
        \ '2': '[2] ',
        \ '3': '[3] ',
        \ '4': '[4] ',
        \ '5': '[5] ',
        \ '6': '[6] ',
        \ '7': '[7] ',
        \ '8': '[8] ',
        \ '9': '[9] '
        \}
