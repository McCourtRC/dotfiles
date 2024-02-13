local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.font = wezterm.font("CommitMono")
config.font_size = 16
config.line_height = 1.2

config.keys = {
  { key = "s", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

  { key = "r", mods = "ALT", action = wezterm.action.RotatePanes("Clockwise") },
  { key = "R", mods = "ALT", action = wezterm.action.RotatePanes("CounterClockwise") },

  { key = "y", mods = "ALT", action = wezterm.action.ActivateCopyMode },
  { key = " ", mods = "ALT", action = wezterm.action.QuickSelect },

  { key = ",", mods = "CMD", action = wezterm.action.MoveTabRelative(-1) },
  { key = ".", mods = "CMD", action = wezterm.action.MoveTabRelative(1) },
}

config.quick_select_patterns = {
  -- "foo.*"
}

return config
