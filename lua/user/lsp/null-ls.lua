local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  vim.notify "Null-LS config ; null-ls not installed"
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  -- will also respect config files for formatters / diagnostics tools. i.e '.prettierrc'
  sources = {
    -- formatting
    formatting.prettierd,
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
    formatting.rustfmt,
    formatting.rubocop,
    -- diagnostics
    diagnostics.eslint_d,
    diagnostics.rubocop,
    -- code actions
    code_actions.eslint_d,
  },
  on_attach = require("user.lsp.handlers").on_attach,
}
