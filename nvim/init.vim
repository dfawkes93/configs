syntax on

call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'preservim/nerdtree' 
Plug 'tomasiser/vim-code-dark'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

autocmd VimResized * :wincmd =
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if !argc() && !exists('s:std_in') | NERDTree| endif

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

command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

nnoremap <SPACE> <Nop>
nmap <silent> gd <Plug>(coc-definition)
let mapleader = "\<Space>"
colorscheme codedark

