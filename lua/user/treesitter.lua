local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify "Treesitter Config nvim-treesitter.configs not installed"
  return
end

configs.setup {
  ensure_installed = {
    "rust",
    "elm",
    "lua",
    "bash",
    "fish",
    "dockerfile",
    "graphql",
    "html",
    "javascript",
    "json",
    "llvm",
    "proto",
    "ruby",
    "scss",
    "toml",
    "tsx",
    "vim",
    "yaml",
    "zig",
  }, -- one of "all", or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- list of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of languages that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  playground = { enable = true },
}
