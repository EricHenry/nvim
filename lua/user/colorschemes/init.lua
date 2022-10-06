require "user.colorschemes.catpuccin"
require "user.colorschemes.nightfox"

-- local colorscheme = "darkplus"
--[[ local colorscheme = "catppuccin" ]]
-- local colorscheme = "nightfox"
local colorscheme = "tokyonight-night"

vim.o.termguicolors = true
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme) -- the .. is string concatenation

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!", "error")
  return
end
