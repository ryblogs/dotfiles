local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Remove the title bar, keep window controls integrated into tab bar
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"

-- Theme
config.color_scheme = 'ayu'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14

-- Clean, minimal tab bar styling
config.use_fancy_tab_bar = true
local border_color = '#333333'
config.window_frame = {
  font = wezterm.font({ family = 'SF Pro', weight = 'Medium' }),
  font_size = 12,
  active_titlebar_bg = '#0f1419',
  inactive_titlebar_bg = '#0f1419',
  border_left_width = '1px',
  border_right_width = '1px',
  border_top_height = '1px',
  border_bottom_height = '1px',
  border_left_color = border_color,
  border_right_color = border_color,
  border_top_color = border_color,
  border_bottom_color = border_color,
}

config.colors = {
  tab_bar = {
    active_tab = { 
      bg_color = '#0f1419', 
      fg_color = '#4cbf99',  -- ayu.teal accent
      intensity = 'Bold',
    },
    inactive_tab = { bg_color = '#0f1419', fg_color = '#666666' },
    inactive_tab_hover = { bg_color = '#111111', fg_color = '#aaaaaa' },
    new_tab = { bg_color = '#0f1419', fg_color = '#666666' },
    new_tab_hover = { bg_color = '#111111', fg_color = '#aaaaaa' },
  },
}

-- Optional: subtle transparency + blur (very macOS-native feel)
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Add padding between MacOS stoplight buttons and the first tab
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  
  -- Pad short titles to a minimum width
  local min_width = 10
  while #title < min_width do
    title = ' ' .. title .. ' '
  end
  
  -- Add padding before the first tab (for stoplight gap)
  if tab.tab_index == 0 then
    title = '   ' .. title
  end
  
  return title
end)

return config
