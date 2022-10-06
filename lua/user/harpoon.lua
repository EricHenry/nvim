local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Harpoon config; lualine not installed", "error")
  return
end

local h_status_ok, harpoon = pcall(require, "harpoon")
if not h_status_ok then
  vim.notify("Harpoon config; lualine not installed", "error")
  return
end
telescope.load_extension "harpoon"
