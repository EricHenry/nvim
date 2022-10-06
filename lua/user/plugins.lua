local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim ..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand tht reloads neovim whenever you save the plugin.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print "Could not load packer"
  return
end

-- Have packer use a popup window
packer.init {
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer mange itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used in lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with cmp and treesitter
  use "numToStr/Comment.nvim" -- easily comment stuff
  use "kyazdani42/nvim-web-devicons"
  use "christianchiarulli/lualine.nvim"
  use {
    "kyazdani42/nvim-tree.lua", -- a nicer file tree explorer
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, nice icons for nvim-tree
    },
  }
  use "moll/vim-bbye" -- won't kick you out of neovim if you delete buffer
  use "folke/which-key.nvim" -- show's a popup for keybindings
  use "goolord/alpha-nvim" -- show a cool dashbard when opening vim without a file
  use "lukas-reineke/indent-blankline.nvim" -- adds indentation guides to all lines
  use "kylechui/nvim-surround" -- surround selections
  use "folke/todo-comments.nvim" -- highlight todo comments
  use "akinsho/toggleterm.nvim" -- terminal inside of nvim
  use "ThePrimeagen/harpoon"
  use "rcarriga/nvim-notify"

  -- Lua dev
  use "folke/lua-dev.nvim"

  -- colors
  use "NvChad/nvim-colorizer.lua"

  -- Colorschemes
  use "lunarvim/darkplus.nvim"
  use "folke/tokyonight.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }
  use "EdenEast/nightfox.nvim"
  use "EricHenry/pop-theme.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- the completeion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippit completions
  use "hrsh7th/cmp-nvim-lsp" -- lsp completions
  use "hrsh7th/cmp-nvim-lua" -- lua completions

  -- snippets
  use "L3MON4D3/LuaSnip" -- snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of community supported snippets

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "RRethy/vim-illuminate" -- highlight other uses of whatever is under cursor
  use "jose-elias-alvarez/null-ls.nvim" -- Formatter / Linter and much more!
  use "lvimuser/lsp-inlayhints.nvim"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use { "j-hui/fidget.nvim", commit = "492492e" }
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
  }

  -- Debugging
  use "mfussenegger/nvim-dap" -- debuging support
  use "rcarriga/nvim-dap-ui" -- debugger ui

  -- Rust
  use "simrat39/rust-tools.nvim" -- additional functionality when using rust
  use { -- plugin that halps manage crates.io dependencies
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local setup = require("user.crates_config").setup
      require("crates").setup(setup)
    end,
  }

  -- Telescope
  use "nvim-telescope/telescope.nvim" -- fuzzy finder plugin
  -- use "nvim-telescope/telescope-media-files.nvim"    -- preview media files
  use "nvim-telescope/telescope-ui-select.nvim" -- dependent of rust-tools

  -- Treesitter
  use { -- syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "nvim-treesitter/playground" -- helper to get the ts node kind
  --[[ use "nvim-treesitter/nvim-treesitter-context" ]]
  use "JoosepAlviste/nvim-ts-context-commentstring" -- treesitter context aware comment strings

  -- Git
  use "lewis6991/gitsigns.nvim" -- show symbols in the gutter

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
