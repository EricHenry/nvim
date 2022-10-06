local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local lspconfig = require "lspconfig"

local servers = {
  "bashls",
  "elmls",
  "jsonls",
  "solargraph",
  "sumneko_lua",
  --[[ "rust_analyzer", -- needs to last for now, see break in for loop below ]]
  "tsserver",
}

lsp_installer.setup {
  ensure_installed = servers,
}

for _, server in pairs(servers) do
  if server == "rust_analyzer" then
    --[[ local status_ok, rust_tools = pcall(require, "rust-tools") ]]
    --[[ if not status_ok then ]]
    --[[   vim.notify "rust-tools config: rust-tools not isntalled" ]]
    --[[   return ]]
    --[[ end ]]
    --[[]]
    vim.notify "skipping rust analyzer config"

    goto continue
  end
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  -- Settings configs can be found in `https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md`
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end
  lspconfig[server].setup(opts)
  ::continue::
end
