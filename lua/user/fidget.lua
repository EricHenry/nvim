local dap_status_ok, fidget = pcall(require, "fidget")
if not dap_status_ok then
  vim.notify "Fidget config: fidget not installed"
  return
end

fidget.setup()
