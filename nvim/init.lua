-- Minimal config leaning on Neovim 0.12 builtins.
-- LSP servers come from pacman: clang lua-language-server rust-analyzer
--   typescript-language-server vscode-html-languageserver

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Plugins ]] (builtin vim.pack, pinned by nvim-pack-lock.json)
vim.pack.add {
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/kylechui/nvim-surround',
}

require('nvim-surround').setup()

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require 'gitsigns'
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
    -- don't override the built-in ]c/[c in diff mode
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
      gs.nav_hunk 'next'
    end, { buffer = bufnr, desc = 'Jump to next hunk' })
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
      gs.nav_hunk 'prev'
    end, { buffer = bufnr, desc = 'Jump to previous hunk' })
  end,
}

-- [[ Options ]]
vim.o.hlsearch = false
vim.o.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect,popup,fuzzy'
vim.o.fileencodings = 'utf8,ibm1047'

-- Transparent background on the default colorscheme
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })

-- Indent guides via listchars (replaces indent-blankline)
vim.o.list = true
local function update_indent_guides()
  local sw = vim.fn.shiftwidth()
  vim.opt_local.listchars = { tab = '┊ ', trail = '·', nbsp = '␣', leadmultispace = '┊' .. string.rep(' ', sw - 1) }
end
vim.api.nvim_create_autocmd('BufWinEnter', { callback = update_indent_guides })
vim.api.nvim_create_autocmd('OptionSet', { pattern = { 'shiftwidth', 'tabstop' }, callback = update_indent_guides })

-- Treesitter highlighting wherever a parser exists (bundled: c lua vim vimdoc markdown query)
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

-- [[ Fuzzy :find / :grep (replaces telescope) ]]
vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildoptions = 'pum,fuzzy'
vim.api.nvim_create_autocmd('CmdlineChanged', {
  pattern = ':',
  callback = function() vim.fn.wildtrigger() end,
})
vim.keymap.set('c', '<Up>', function() return vim.fn.wildmenumode() == 1 and '<C-e><Up>' or '<Up>' end, { expr = true })
vim.keymap.set('c', '<Down>', function() return vim.fn.wildmenumode() == 1 and '<C-e><Down>' or '<Down>' end, { expr = true })

local files_cache
function _G.FindFiles(arg, _)
  files_cache = files_cache or vim.fn.systemlist { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
  return arg == '' and files_cache or vim.fn.matchfuzzy(files_cache, arg)
end
vim.o.findfunc = 'v:lua.FindFiles'
vim.api.nvim_create_autocmd('CmdlineEnter', { pattern = ':', callback = function() files_cache = nil end })

vim.o.grepprg = 'rg --vimgrep --smart-case --hidden --glob !.git'
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'grep', command = 'cwindow' })

vim.keymap.set('n', '<leader>sf', ':find ', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader><space>', ':buffer ', { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>?', '<Cmd>browse oldfiles<CR>', { desc = 'Recently opened files' })
vim.keymap.set('n', '<leader>sh', ':help ', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sg', ':silent grep! ', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', '<Cmd>silent grep! -w <cword><CR>', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', vim.diagnostic.setqflist, { desc = '[S]earch [D]iagnostics' })

-- [[ Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move by display line when wrapped
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format buffer' })

-- Seamless window/tmux pane navigation (replaces tmux.nvim; pairs with is_vim in tmux.conf)
for key, dir in pairs { h = 'L', j = 'D', k = 'U', l = 'R' } do
  vim.keymap.set('n', '<C-' .. key .. '>', function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if vim.env.TMUX and vim.api.nvim_get_current_win() == win then
      vim.system { 'tmux', 'select-pane', '-' .. dir }
    end
  end)
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ LSP ]] (builtin vim.lsp.config; servers enabled only if installed)
local servers = {
  clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
  },
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      },
    },
  },
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
  },
  ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  },
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { 'package.json', '.git' },
    init_options = { provideFormatter = true },
  },
}
for name, config in pairs(servers) do
  if vim.fn.executable(config.cmd[1]) == 1 then
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

-- Builtin defaults already cover: grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO document symbols, K hover,
-- <C-s> signature help (insert), [d ]d diagnostics, an/in selection.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
    end

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
    nmap('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    vim.api.nvim_buf_create_user_command(args.buf, 'Format', function() vim.lsp.buf.format() end,
      { desc = 'Format current buffer with LSP' })

    if client:supports_method 'textDocument/completion' then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- [[ Completion keys ]] (builtin popup + vim.snippet)
local function pum() return vim.fn.pumvisible() == 1 end
vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { desc = 'Trigger completion' })
vim.keymap.set('i', '<CR>', function()
  if not pum() then return '<CR>' end
  return vim.fn.complete_info({ 'selected' }).selected == -1 and '<C-n><C-y>' or '<C-y>'
end, { expr = true })
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if pum() then return '<C-n>' end
  if vim.snippet.active { direction = 1 } then return '<Cmd>lua vim.snippet.jump(1)<CR>' end
  return '<Tab>'
end, { expr = true })
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if pum() then return '<C-p>' end
  if vim.snippet.active { direction = -1 } then return '<Cmd>lua vim.snippet.jump(-1)<CR>' end
  return '<S-Tab>'
end, { expr = true })

-- vim: ts=2 sts=2 sw=2 et
