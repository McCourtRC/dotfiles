local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.font = wezterm.font("CommitMono")
config.font_size = 16
config.line_height = 1.2

-- Grain texture backgrounds
local config_dir = wezterm.config_dir or os.getenv("HOME") .. "/.config/wezterm"
local grain_textures = {
  mocha = config_dir .. "/grain-texture-mocha.png",
  macchiato = config_dir .. "/grain-texture-macchiato.png",
}

config.window_background_image = grain_textures.mocha
config.window_background_image_hsb = {
  brightness = 1.0,
  saturation = 1.0,
  hue = 1.0,
}

config.keys = {
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },

  { key = "s", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

  { key = "h", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 10 }) },
  { key = "j", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 10 }) },
  { key = "k", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 10 }) },
  { key = "l", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 10 }) },
  { key = "<", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 20 }) },
  { key = ">", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 20 }) },

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
