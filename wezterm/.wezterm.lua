local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Powerline Symbol for the continuous forward slant (/)
local SEPARATOR = utf8.char(0xe0bc)

-- Right Click to Copy/Paste
config.mouse_bindings = {
    -- Right click: copy if there's a selection, otherwise paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act.PasteFrom("Clipboard"), pane)
            end
        end),
    },
}

-- Keymaps
config.keys = {
    -- Move tab relative to its current position
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.MoveTabRelative(-1),
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.MoveTabRelative(1),
    },
}

-- Set the cursor to a blinking vertical bar
config.default_cursor_style = 'BlinkingBar'

-- Colors
local TAHOE_GRAY = '#383838'
local BAR_BG = '#0f1419'
local ACTIVE_BG = '#4CBF99'
local ACTIVE_FG = '#111111'
local INACTIVE_BG = '#1a1f26'
local INACTIVE_FG = '#5c6773'
local HOVER_BG = '#252a30'

-- Window Decorations
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
-- Window Border (Tahoe Liquid Glass)
config.window_frame = {
    border_left_color = TAHOE_GRAY,
    border_right_color = TAHOE_GRAY,
    border_bottom_color = TAHOE_GRAY,
    border_top_color = TAHOE_GRAY,
    border_left_width = '1px',
    border_right_width = '1px',
    border_bottom_height = '1px',
    border_top_height = '1px',
}

-- Theme & Colors
config.color_scheme = 'ayu'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.show_new_tab_button_in_tab_bar = true

config.colors = {
    tab_bar = {
        background = BAR_BG,
        new_tab = { bg_color = BAR_BG, fg_color = INACTIVE_FG },
        new_tab_hover = { bg_color = BAR_BG, fg_color = ACTIVE_BG },
    },
}

-- Window Layout
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Process icons
local process_icons = {
    ['nvim']    = wezterm.nerdfonts.custom_vim,
    ['vim']     = wezterm.nerdfonts.custom_vim,
    ['zsh']     = wezterm.nerdfonts.cod_terminal,
    ['bash']    = wezterm.nerdfonts.cod_terminal,
    ['fish']    = wezterm.nerdfonts.cod_terminal,
    ['node']    = wezterm.nerdfonts.md_nodejs,
    ['python']  = wezterm.nerdfonts.dev_python,
    ['python3'] = wezterm.nerdfonts.dev_python,
    ['git']     = wezterm.nerdfonts.dev_git,
    ['lazygit'] = wezterm.nerdfonts.dev_git,
    ['docker']  = wezterm.nerdfonts.dev_docker,
    ['cargo']   = wezterm.nerdfonts.dev_rust,
    ['go']      = wezterm.nerdfonts.md_language_go,
    ['ssh']     = wezterm.nerdfonts.md_server,
    ['sudo']    = wezterm.nerdfonts.fa_hashtag,
    ['micro']   = wezterm.nerdfonts.md_file_document_edit,
    ['yazi']    = wezterm.nerdfonts.md_folder_open,
    ['helix']   = wezterm.nerdfonts.md_dna, -- Often used for Helix's helix logo
    ['hx']      = wezterm.nerdfonts.md_dna,
    ['btop']    = wezterm.nerdfonts.md_chart_areaspline,
    ['htop']    = wezterm.nerdfonts.md_chart_areaspline,
    ['top']     = wezterm.nerdfonts.md_chart_areaspline,
}

local function get_process_name(pane)
    local process = pane.foreground_process_name or ''
    return process:match('([^/\\]+)$') or ''
end

local function get_tab_title(pane)
    local process = get_process_name(pane)
    local shells = { zsh = true, bash = true, fish = true, sh = true }
    if shells[process] then
        local cwd = pane.current_working_dir
        if cwd then return cwd.file_path:match('([^/]+)/?$') or '~' end
    end
    return process
end

-- Tab Title Formatting
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover)
    local pane = tab.active_pane
    local title = get_tab_title(pane)
    local process = get_process_name(pane)
    local icon = process_icons[process] or wezterm.nerdfonts.cod_terminal

    local display_title = string.format(' %d:  %s  %s ', tab.tab_index + 1, icon, title)

    local bg = INACTIVE_BG
    local fg = INACTIVE_FG

    if tab.is_active then
        bg = ACTIVE_BG
        fg = ACTIVE_FG
    elseif hover then
        bg = HOVER_BG
        fg = ACTIVE_BG
    end

    -- Look ahead to the NEXT tab's background to prevent the "sliver" bug
    local next_tab_bg = BAR_BG
    if tab.tab_index < #tabs - 1 then
        local next_tab = tabs[tab.tab_index + 2] -- tabs is 1-indexed here
        if next_tab.is_active then
            next_tab_bg = ACTIVE_BG
        else
            next_tab_bg = INACTIVE_BG
        end
    end

    return {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = display_title },
        { Background = { Color = next_tab_bg } },
        { Foreground = { Color = bg } },
        { Text = SEPARATOR },
    }
end)

-- Status Bar Formatting
wezterm.on('update-status', function(window, pane)
    local time = wezterm.strftime('%H:%M')
    window:set_right_status(wezterm.format({
        { Background = { Color = BAR_BG } },
        { Foreground = { Color = ACTIVE_BG } },
        { Text = utf8.char(0xe0be) }, -- Left-facing slant to start the clock block
        { Background = { Color = ACTIVE_BG } },
        { Foreground = { Color = ACTIVE_FG } },
        { Text = ' ' .. wezterm.nerdfonts.md_clock_outline .. ' ' .. time .. ' ' },
    }))
end)

return config
