local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
	vim.notify("Surround config: nvim-surround not installed")
	return
end

surround.setup({})
