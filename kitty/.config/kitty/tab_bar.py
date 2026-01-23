# ~/.config/kitty/tab_bar.py
# Ayu Dark theme with process icons and clock

import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
)

timer_id = None

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Ayu Dark Colors
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BG = 0x0e1419
FG = 0xe5e1cf
ACCENT = 0x95e5cb        # teal
ACCENT_FG = 0x0e1419     # dark text on teal
INACTIVE_BG = 0x1a1f29
INACTIVE_FG = 0x5c6773
CLOCK_FG = 0x95e5cb
SEP_FG = 0x5c6773

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Nerd Font Icons (requires a Nerd Font)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ICON_MAP: dict[str, str] = {
    # Editors
    "nvim": "󰕷",
    "vim": "",
    "nano": "󰔷",
    "micro": "󰬴",
    "code": "󰨞",
    "emacs": "",
    
    # Shells
    "zsh": "󱆃",
    "bash": "",
    "fish": "󰈺",
    "sh": "",
    
    # Languages / Runtimes
    "python": "󰌠",
    "python3": "󰌠",
    "node": "󰎙",
    "ruby": "",
    "cargo": "",
    "rustc": "",
    "go": "",
    "java": "",
    "lua": "",
    "perl": "",
    
    # Package managers
    "npm": "",
    "yarn": "",
    "pnpm": "󰋁",
    "pip": "󱆅",
    "brew": "󱄖",
    
    # Git
    "git": "",
    "lazygit": "󰊢",
    "gh": "",
    "tig": "",
    
    # Docker / Containers
    "docker": "󰡨",
    "docker-compose": "󰡨",
    "podman": "󰡨",
    "kubectl": "󱃾",
    
    # System
    "htop": "󰍛",
    "btop": "󰍛",
    "top": "󰍛",
    "ssh": "󰣀",
    "man": "󰙃",
    "less": "󰙃",
    "cat": "󰄛",
    "bat": "󰄛",
    
    # File managers
    "ranger": "󰙅",
    "lf": "󰙅",
    "yazi": "󰙅",
    "mc": "󰙅",
    
    # Network
    "curl": "󰖟",
    "wget": "󰖟",
    "ping": "󰖟",
    
    # Build tools
    "make": "",
    "cmake": "󰔷",
    "ninja": "󰝴",
    
    # Other
    "tmux": "",
    "fzf": "󰍉",
    "rg": "󰍉",
    "fd": "󰍉",
    "find": "󰍉",
    "grep": "󰍉",
}
DEFAULT_ICON = ""

# Powerline slanted separator
# U+E0BC is the slanted separator that creates the angled tab look
SLANT = "\ue0bc"

def get_process_icon(cmdline: list) -> str:
    """Get icon for the foreground process."""
    if not cmdline:
        return DEFAULT_ICON
    proc = cmdline[0].split("/")[-1] if cmdline[0] else ""
    return ICON_MAP.get(proc, DEFAULT_ICON)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Draw a single tab with process icon and slanted powerline style."""
    
    # Get the foreground process for active tab
    icon = DEFAULT_ICON
    if tab.is_active:
        try:
            boss = get_boss()
            if boss and boss.active_tab:
                window = boss.active_tab.active_window
                if window and window.child:
                    cmdline = window.child.foreground_cmdline
                    icon = get_process_icon(cmdline)
        except Exception:
            pass
    
    # Tab colors
    if tab.is_active:
        fg = ACCENT_FG
        bg = ACCENT
    else:
        fg = INACTIVE_FG
        bg = INACTIVE_BG
    
    # Determine previous tab's background for the slant transition
    if extra_data.prev_tab is not None:
        prev_bg = ACCENT if extra_data.prev_tab.is_active else INACTIVE_BG
        # Draw the slanted separator (transition FROM previous TO current)
        screen.cursor.fg = as_rgb(prev_bg)
        screen.cursor.bg = as_rgb(bg)
        screen.draw(SLANT)
    
    # Draw tab content
    screen.cursor.fg = as_rgb(fg)
    screen.cursor.bg = as_rgb(bg)
    
    # Truncate title if needed
    title = tab.title
    max_title = max_tab_length - 6
    if len(title) > max_title and max_title > 0:
        title = title[:max_title - 1] + "…"
    
    if tab.is_active:
        tab_content = f" {index}: {icon} {title} "
    else:
        tab_content = f" {index}: {title} "
    
    screen.draw(tab_content)
    
    # If this is the last tab, draw final slant and clock
    if is_last:
        # Final slant back to bar background
        screen.cursor.fg = as_rgb(bg)
        screen.cursor.bg = as_rgb(BG)
        screen.draw(SLANT)
        
        # Draw clock on the right
        _draw_right_status(screen)
    
    return screen.cursor.x


def _draw_right_status(screen: Screen) -> None:
    """Draw clock and other status on the right side."""
    
    clock_icon = "󰥔"  # nf-md-clock_outline
    clock = datetime.datetime.now().strftime("%H:%M")
    right_status = f" {clock_icon} {clock} "
    
    # Calculate padding to push clock to the right
    padding = screen.columns - screen.cursor.x - len(right_status)
    
    if padding > 0:
        screen.cursor.fg = as_rgb(BG)
        screen.cursor.bg = as_rgb(BG)
        screen.draw(" " * padding)
    
    # Draw clock
    screen.cursor.fg = as_rgb(CLOCK_FG)
    screen.cursor.bg = as_rgb(BG)
    screen.draw(right_status)


def redraw_tab_bar(timer_id) -> None:
    """Refresh tab bar for clock updates."""
    try:
        boss = get_boss()
        if boss:
            for tm in boss.all_tab_managers:
                tm.mark_tab_bar_dirty()
    except Exception:
        pass


# Refresh every 30 seconds for the clock
add_timer(redraw_tab_bar, 30.0, True)
