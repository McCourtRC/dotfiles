local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load palette from neovim colorscheme (single source of truth)
local palettes_dir = os.getenv("HOME") .. "/repos/bitlikethis/corlang/corl/colorscheme/lua/coral/palettes"
local shore = dofile(palettes_dir .. "/shore.lua")

-- Build wezterm color scheme from palette
local function make_color_scheme(p)
  return {
    foreground = p.pearl,
    background = p.depth,
    cursor_fg = p.depth,
    cursor_bg = p.pearl,
    cursor_border = p.pearl,
    selection_fg = p.pearl,
    selection_bg = p.current,

    ansi = {
      p.pearl,      -- 0 black
      p.urchin,     -- 1 red
      p.seafoam,    -- 2 green
      p.anglerfish, -- 3 yellow
      p.jellyfish,  -- 4 blue
      p.anemone,    -- 5 magenta
      p.coral,      -- 6 cyan
      p.foam,       -- 7 white
    },
    brights = {
      p.silt,       -- 8 bright black
      p.urchin,     -- 9 bright red
      p.plankton,   -- 10 bright green
      p.starfish,   -- 11 bright yellow
      p.nautilus,   -- 12 bright blue
      p.mantaray,   -- 13 bright magenta
      p.coral,      -- 14 bright cyan
      p.pearl,      -- 15 bright white
    },

    tab_bar = {
      background = p.twilight,
      active_tab = {
        bg_color = p.depth,
        fg_color = p.pearl,
      },
      inactive_tab = {
        bg_color = p.twilight,
        fg_color = p.foam,
      },
      inactive_tab_hover = {
        bg_color = p.current,
        fg_color = p.pearl,
      },
    },
  }
end

config.color_schemes = {
  ["Coral Shore"] = make_color_scheme(shore),
}

-- config.color_scheme = "Coral Shore"
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
  shore_v6 = config_dir .. "/coral_shore_grain_v6.png",
  shore_v9 = config_dir .. "/coral_shore_grain_v9.png",
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
