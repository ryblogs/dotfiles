# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  # zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='micro'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --- Ryblogs

# EZA
# Remove any existing ls alias (from Oh My Zsh or plugins)
unalias ls 2>/dev/null || true
# Only use enhanced eza when output goes to terminal
ls() {
    if [ -t 1 ]; then
        eza --long -a --group-directories-first --icons=always "$@"
    else
        command ls "$@"
    fi
}

# ZOXIDE
eval "$(zoxide init zsh --cmd cd)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# HOMEBREW
steep () {
    brew update
    brew upgrade
    brew upgrade --cask
    brew autoremove
    brew cleanup
    brew doctor
}

# ATUIN
eval "$(atuin init zsh)"

# ============================================================================
# ZELLIJ TERMINAL MULTIPLEXER CONFIGURATION
# ============================================================================
# Automatically start zellij when opening a new terminal
# eval "$(zellij setup --generate-auto-start zsh)"
# Short alias for quicker typing
alias z=zellij
# ----------------------------------------------------------------------------
# Custom Functions
# ----------------------------------------------------------------------------
# Override clear command to work properly within zellij
# When inside zellij, clear both terminal and zellij scrollback
clear() {
    if [[ -n "$ZELLIJ" ]]; then
        command clear && zellij action clear
    else
        command clear
    fi
}
# Custom session completion function for intelligent tab completion
# Shows session names with descriptions (e.g., "main: RUNNING (1 tabs)")
# Note: see here: https://github.com/zellij-org/zellij/issues/1933
_zellij_sessions() {
    local line sessions desc
    # Get list of sessions without formatting (zellij ls -n)
    sessions=("${(@f)$(zellij ls -n)}")
    local -a session_names_with_desc

    # Parse each session line to extract name and description
    for line in "${sessions[@]}"; do
        session_name=${line%% *}    # Everything before first space (session name)
        desc=${line#* }             # Everything after first space (description)
        session_names_with_desc+=("$session_name:$desc")
    done

    # Provide completion options with descriptions
    _describe -t sessions 'active session' session_names_with_desc
}
# ----------------------------------------------------------------------------
# Tab Completion Setup
# ----------------------------------------------------------------------------
# Set up enhanced completion with command aliases and smart session completion
# The sed script below modifies the generated completion to:
# 1. Add single-letter aliases: (attach) -> (attach|a), (kill-session) -> (kill-session|k), etc.
# 2. Replace default session completion with our custom _zellij_sessions function
# 3. Fix the compdef registration line
. <(zellij setup --generate-completion zsh | sed -E '
    s/^\((attach)\)/(\1|a)/
    s/^\((kill-session)\)/(\1|k)/
    s/^\((delete-session)\)/(\1|d)/
    s/::session-name -- Name of the session to attach to:/::session-name:_zellij_sessions/
    s/::target-session -- Name of target session:/::target-session:_zellij_sessions/
    s/^(_(zellij) ).*/compdef \1\2/
')
# Enable tab completion for our 'z' alias
compdef z=_zellij

# UV
# Fix completions for uv run to autocomplete .py files
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files -g "*.py"'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# GO
export PATH=$PATH:$(go env GOPATH)/bin

# GLOBDOTS
setopt globdots

# AIDER
export AIDER_OPENAI_API_KEY=none
export AIDER_OPENAI_API_BASE=http://localhost:8888/v1
export AIDER_MODEL=openai/Qwen/Qwen3-30B-A3B-MLX-4bit

# STARSHIP
eval "$(starship init zsh)"
