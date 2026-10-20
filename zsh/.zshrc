# =========================
# Completion (needed for Tab features like git branches)
# =========================
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -Uz compinit
compinit -C

# =========================
# NVM (Node Version Manager)
# =========================
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# Auto-switch Node version based on .nvmrc
autoload -U add-zsh-hook

load-nvmrc() {
  local node_version nvmrc_path
  nvmrc_path=$(nvm_find_nvmrc)

  if [ -n "$nvmrc_path" ]; then
    # There is an .nvmrc somewhere above or in this folder
    node_version=$(cat "$nvmrc_path")

    if [ "$node_version" = "system" ]; then
      nvm use system >/dev/null
    elif [ "$(nvm current)" != "$node_version" ]; then
      nvm use "$node_version" >/dev/null
    fi
  else
    # No .nvmrc in this directory tree → go back to default
    if [ "$(nvm current)" != "default" ]; then
      nvm use default >/dev/null
    fi
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# =========================
# History settings
# =========================
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt INC_APPEND_HISTORY      # save history as commands are entered
setopt SHARE_HISTORY           # share history across terminals
setopt HIST_IGNORE_ALL_DUPS    # don't store duplicate commands
setopt HIST_REDUCE_BLANKS      # trim extra spaces

# =========================
# Git aliases (+ branch completion)
# =========================
alias gco="git checkout"        # legacy (still useful sometimes)
alias gsw="git switch"          # modern branch switching
alias gcm="git commit -m"
alias gaa="git add ."
alias gs="git status -sb"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# Make alias completion behave like the real git subcommands
compdef gco=git-checkout 2>/dev/null || compdef gco=git
compdef gsw=git-switch   2>/dev/null || compdef gsw=git

# =========================
# General aliases
# =========================

# Replace the default `ls` with `eza` (a modern `ls` alternative).
# --icons: shows file/folder icons (needs a Nerd Font in your terminal)
# --group-directories-first: lists folders before files
alias ls="eza --icons --group-directories-first"

# =========================
# FZF integration
# =========================

# If the FZF Zsh integration file exists, load it.
# This enables FZF key bindings + shell integration, typically:
# - Ctrl + R : fuzzy search your command history
# - Ctrl + T : fuzzy pick files/paths from the current directory
# - Alt + C  : fuzzy jump (cd) into a directory
# The check prevents errors if ~/.fzf.zsh doesn't exist.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =========================
# Zsh plugins (Homebrew)
# =========================

# Autosuggestions from history (ghost text)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be last plugin)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =========================
# History prefix search with arrows
# Type a prefix, then use ↑ / ↓ to cycle matching history
# =========================
bindkey '^[[A' history-beginning-search-backward   # Up arrow
bindkey '^[[B' history-beginning-search-forward    # Down arrow

# =========================
# Starship prompt (keep near the end)
# =========================
eval "$(starship init zsh)"
