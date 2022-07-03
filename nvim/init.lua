--- LUA Conf :)
--
-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

require('packer').startup(function(use)
  -- My plugins here
	use 'christoomey/vim-tmux-navigator'
	use 'tpope/vim-surround'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'preservim/nerdtree'
    -- LSP
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
    -- LSP/cmp
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'

    -- TreeSitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- Rice
	use 'ryanoasis/vim-devicons'
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'
	-- use 'NLKNguyen/papercolor-theme'
	-- use 'sainnhe/gruvbox-material'
    use 'ayu-theme/ayu-vim'
    -- Misc
    use 'jose-elias-alvarez/null-ls.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-------------------- REQUIRES -------------------------------

require "user.lsp"
require "user.cmp"
require "user.treesitter"
require "user.telescope"

-------------------- OTHER -------------------------------
cmd("autocmd VimResized * :wincmd =")
cmd("autocmd StdinReadPre * let s:std_in=1")
cmd("autocmd VimEnter * if !argc() && !exists('s:std_in') | NERDTree| endif")

opt.errorbells = false
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.nu = true
opt.relativenumber = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
-- vim.opt.undodir =~/.vim/undodir
opt.undofile = true
opt.incsearch = true
opt.hidden = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.background = "dark"
opt.termguicolors = true

map("n","<leader>-","wincmd _<cr>:wincmd \\|<cr>")
map("n","<leader>=","wincmd =<cr>")
map("n","<SPACE>","<Nop>")

g.mapleader = "\\<Space>"
g.airline_powerline_fonts = 1
-- cmd "colorscheme PaperColor"
-- cmd "colorscheme gruvbox-material"
cmd "colorscheme ayu"
cmd("highlight Normal guibg=NONE")
cmd("highlight clear SignColumn") 