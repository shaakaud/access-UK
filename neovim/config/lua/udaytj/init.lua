-- Lua Configuration (init.lua)

require("udaytj.remap")
require("udaytj.set")
-- require'lspconfig'.pyright.setup{}
require'lspconfig'.pylsp.setup{}
require'lspconfig'.golangci_lint_ls.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.helm_ls.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.clangd.setup{}
require('cscope_maps').setup()

-- Basic vim configs -  uday's preferences
vim.cmd('set hlsearch')
vim.cmd('set number')
vim.cmd('set autoindent')
vim.cmd('set smartindent')
vim.cmd('set cindent')
vim.cmd('set nocompatible')
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set backspace=2')
vim.cmd('set ruler')
vim.cmd('set incsearch')
vim.cmd('set ttyfast')
vim.cmd('set expandtab')
vim.cmd('set laststatus=2')
vim.cmd('set colorcolumn=80')     -- to draw a vertical line at column 80 and highlight all red after that
vim.cmd('set nowrap')
vim.cmd('set tw=0')
vim.cmd('colorscheme solarized')  --To set solaraized color scheme
vim.cmd('filetype plugin on')
vim.cmd('syntax on')

-- vim globals
vim.g.solarized_termcolors=16  -- To set solaraized color scheme
vim.g.solarized_termtrans=1    -- To set solaraized color scheme

-- global key bindings
-- <C-Space> - to force autocomplete. This is coming from cmp package. :help cmp for more info

-- look into :help wildmenu or :help wildchar to find default keybindings in command-line mode
-- vim.api.nvim_set_keymap('c', '<Down>', '<C-n>', { noremap = true, silent = true }) -- Remap wildmenu navigation keys (Down arrow key is remapped to the <C-n> (Ctrl + n))
-- vim.api.nvim_set_keymap('c', '<Up>', '<C-p>', { noremap = true, silent = true }) -- Remap wildmenu navigation keys (Up arrow key is remapped to <C-p> (Ctrl + p))
