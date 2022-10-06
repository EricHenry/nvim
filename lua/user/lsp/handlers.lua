local M = {} -- how to define a module

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
  local icons = require "user.icons"
  local signs = {

    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_lines = false,
    virtual_text = false,
    -- virtual_text = {
    --   -- spacing = 7,
    --   -- update_in_insert = false,
    --   -- severity_sort = true,
    --   -- prefix = "<-",
    --   prefix = " ●",
    --   source = "if_many", -- Or "always"
    --   -- format = function(diag)
    --   --   return diag.message .. "blah"
    --   -- end,
    -- },

    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      -- border = {"▄","▄","▄","█","▀","▀","▀","█"},
      source = "if_many", -- Or "always"
      header = "",
      prefix = "",
      -- width = 40,
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    -- width = 60,
    -- height = 30,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    -- width = 60,
    -- height = 30,
  })
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    vim.notify "LSP CONFIG - illuminate not installed"
    return
  end
  illuminate.on_attach(client)
  -- end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local set_keymap = vim.api.nvim_buf_set_keymap
  set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
  set_keymap(bufnr, "n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)
  set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  set_keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<cr>", opts)
  set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
  set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]] -- creates a new command that you can input into neovim via ':'
end

-- local ignore_server_formatting = {
--   "sumneko_lua",
--   "tsserver",
--   "rust_analyzer",
-- }

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      -- disable lsp servers from formating the document, where null-ls should hanldle it
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end
  navic.attach(client, bufnr)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) -- needed for formatting on save
M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  attach_navic(client, bufnr)

  -- this is for supporting format on save
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
        vim.lsp.buf.format { bufnr = bufnr }
        -- lsp_formatting(bufnr)
      end,
    })
  end
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
--
-- local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- if not status_ok then
--   return
-- end

-- M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities) -- cmp hook to work with capabilities

return M -- return module
