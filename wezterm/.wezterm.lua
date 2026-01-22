local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"

-- Theme
config.color_scheme = 'ayu'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14

-- Window
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Ayu Dark colors for tabline
local ayu = {
  bg = '#0f1419',
  bg_highlight = '#1a1f26',
  fg = '#bfbdb6',
  fg_dim = '#5c6773',
  accent = '#4cbf99',
  orange = '#ffb454',
  yellow = '#e6b450',
  red = '#f07178',
  blue = '#59c2ff',
}

-- Setup tabline
tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'ayu',
    theme_overrides = {
      normal_mode = {
        a = { fg = ayu.bg, bg = ayu.accent },
        b = { fg = ayu.accent, bg = ayu.bg_highlight },
        c = { fg = ayu.fg_dim, bg = ayu.bg },
      },
      copy_mode = {
        a = { fg = ayu.bg, bg = ayu.yellow },
        b = { fg = ayu.yellow, bg = ayu.bg_highlight },
        c = { fg = ayu.fg_dim, bg = ayu.bg },
      },
      search_mode = {
        a = { fg = ayu.bg, bg = ayu.blue },
        b = { fg = ayu.blue, bg = ayu.bg_highlight },
        c = { fg = ayu.fg_dim, bg = ayu.bg },
      },
      tab = {
        active = { fg = ayu.accent, bg = ayu.bg_highlight },
        inactive = { fg = ayu.fg_dim, bg = ayu.bg },
        inactive_hover = { fg = ayu.accent, bg = ayu.bg_highlight },
      },
    },
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = {
      'index',
      { 'process', padding = { left = 0, right = 1 } },
    },
    tabline_x = { },
    tabline_y = { 'datetime' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})

tabline.apply_to_config(config)

return config
