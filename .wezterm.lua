local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.font = wezterm.font("CommitMono")
config.font_size = 16
config.line_height = 1.2

config.quick_select_patterns = {
  -- "foo.*"
}

return config
