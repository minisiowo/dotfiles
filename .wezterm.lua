local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.default_domain = "WSL:archlinux"

config.font = wezterm.font("Iosevka Term")
config.font_size = 10.0

config.color_scheme = "Catppuccin Mocha"
config.colors = {
  background = "#202020",
}

config.enable_tab_bar = false

config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.scrollback_lines = 10000

config.keys = {
  { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
  { key = "Enter", mods = "CTRL", action = wezterm.action.SendString("\r") },
  { key = "Enter", mods = "ALT", action = wezterm.action.SendString("\x1b\r") },
}

return config
