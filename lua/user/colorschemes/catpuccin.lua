local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  vim.notify "Catppuccin config: catppuccin not installed"
  return
end

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

catppuccin.setup()
