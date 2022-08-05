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
	use 'preservim/nerdtree'

    -- Telescope
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'

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

    -- Debug
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'

    -- TreeSitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Rice
	use 'ryanoasis/vim-devicons'
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'
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
require "user.dap"
require "user.dapui"
require "user.folding"
require "user.airline"

-------------------- KEYMAPS -------------------------------

g.mapleader = " "
g.maplocalleader = " "

-- debug
map("n", "<F5>", ":lua require'dap'.continue()<CR>")
map("n", "<F7>", ":lua require'dap'.step_over()<CR>")
map("n", "<F8>", ":lua require'dap'.step_into()<CR>")
map("n", "<F9>", ":lua require'dap'.step_out()<CR>")
map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

-- Normal --
-- Buffers
map("n", "<leader>q", ":bp<cr>:bd #<cr>")
map("n", "<leader>w", ":w<cr>")
map("n", "<leader><Tab>", "<cmd>Telescope buffers theme=cursor previewer=false<CR>")
--map("n", "<leader>wq", "<leader>w <leader>q")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
map("n","<leader>-","wincmd _<cr>:wincmd \\|<cr>")
map("n","<leader>=","wincmd =<cr>")
map("n","<SPACE>","<Nop>")

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Telescope
map("n", "<leader>f", "<cmd>Telescope find_files<cr>")
map("n", "<c-t>", "<cmd>Telescope live_grep<cr>")

-- nerdtree
map ("n", "<c-p>", "<cmd>NERDTreeToggle<cr>")

-- airline
map ("n", "<leader>1", "<Plug>AirlineSelectTab1" )
map ("n", "<leader>2", "<Plug>AirlineSelectTab2" )
map ("n", "<leader>3", "<Plug>AirlineSelectTab3" )
map ("n", "<leader>4", "<Plug>AirlineSelectTab4" )
map ("n", "<leader>5", "<Plug>AirlineSelectTab5" )
map ("n", "<leader>6", "<Plug>AirlineSelectTab6" )
map ("n", "<leader>7", "<Plug>AirlineSelectTab7" )
map ("n", "<leader>8", "<Plug>AirlineSelectTab8" )
map ("n", "<leader>9", "<Plug>AirlineSelectTab9" )
map ("n", "<leader>0", "<Plug>AirlineSelectTab0" )
map ("n", "<leader>-", "<Plug>AirlineSelectPrevTab" )
map ("n", "<leader>+", "<Plug>AirlineSelectNextTab" )
--
-- format
map("n", "<leader>cf", "<cmd>:lua vim.lsp.buf.formatting()<cr>")

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>")
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
opt.hlsearch = false
opt.ignorecase = true

-- cmd "colorscheme PaperColor"
-- cmd "colorscheme gruvbox-material"
cmd "colorscheme ayu"
cmd("highlight Normal guibg=NONE")
cmd("highlight clear SignColumn") 
