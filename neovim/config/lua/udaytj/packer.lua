-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'williamboman/mason.nvim'},           -- Optional
		  {'williamboman/mason-lspconfig.nvim'}, -- Optional
		  {'neovim/nvim-lspconfig'},             -- Required

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},     -- Required
		  {'hrsh7th/cmp-nvim-lsp'}, -- Required
		  {'L3MON4D3/LuaSnip'},     -- Required
	  }
  }

  -- use({
  --    "dhananjaylatkar/vim-gutentags", -- cscope_maps.nvim requires this patch
  --    after = "cscope_maps.nvim",
  --})

  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use ('tpope/vim-fugitive')
  use ('natecraddock/sessions.nvim')
  use ('altercation/vim-colors-solarized')
  -- use ('ishan9299/nvim-solarized-lua')
  use ('vim-scripts/vimtabs.vim')
  use ('vim-airline/vim-airline')
  use ('vim-airline/vim-airline-themes')
  use ('majutsushi/tagbar')  -- used in vim-airline display
  use ('preservim/nerdtree') -- used in vim-airline display
  use ('ntpeters/vim-better-whitespace') -- used in vim-airline display
  use ('dhananjaylatkar/cscope_maps.nvim') -- cscope keymaps
  use ('folke/which-key.nvim') -- optional [for whichkey hints] - cscope related
  use ('ibhagwan/fzf-lua') -- optional [for picker="fzf-lua"] - cscope related
  use ('nvim-tree/nvim-web-devicons') -- provides colorful and contextual icons for files, directories in telescope


  if packer_bootstrap then
    require('packer').sync()
  end

end)
