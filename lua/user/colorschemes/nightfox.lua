local status_ok, nightfox = pcall(require, "nightfox")
if not status_ok then
  vim.notify "Nightfox config: nightfox not installed"
  return
end

nightfox.setup()
