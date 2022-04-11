syntax on

call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

autocmd VimResized * :wincmd =
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set relativenumber
set nowrap
set noswapfile
set nobackup
set undodir =~/.vim/undodir
set undofile
set incsearch
set hidden
set scrolloff=8
set sidescrolloff=8

let mapleader = "\<space>"

