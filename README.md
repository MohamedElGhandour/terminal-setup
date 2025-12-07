# 🚀 Mohamed’s Mac Terminal Setup (2025)

This document contains all steps to recreate my complete Mac terminal environment.  
It includes Zsh configuration, plugins, fonts, fzf, Starship (Pure preset), and essential CLI tools.

---

## 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## 2. Install essential CLI tools

```bash
brew install git wget tree fzf jq bat eza ripgrep nvm
```

### Tools included:

- **git** → version control
- **wget** → downloads
- **tree** → directory tree
- **fzf** → fuzzy search (Ctrl + R, Alt + C, Ctrl + T)
- **jq** → JSON formatter
- **bat** → better cat
- **eza** → modern ls with icons
- **ripgrep (rg)** → super-fast text search
- **nvm** → Node version manager

---

## 3. Configure NVM + Install Node

```bash
mkdir ~/.nvm
```

Add to `~/.zshrc`:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
```

Install latest LTS:

```bash
nvm install --lts
```

---

## 4. Install Zsh plugins

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting
```

---

## 5. Install Starship (Pure preset)

```bash
brew install starship
mkdir -p ~/.config
starship preset pure-preset -o ~/.config/starship.toml
```

---

## 6. Configure FZF

```bash
$(brew --prefix)/opt/fzf/install
```

Select **YES** for:

- auto-completion
- key bindings
- shell integration

---

## 7. Install Nerd Font (required for icons)

```bash
brew install --cask font-meslo-lg-nerd-font
```

Then set **MesloLGS Nerd Font** in your Terminal/iTerm2.

---

## 8. Final `.zshrc` configuration

_(clean, optimized, and ready to paste — includes all settings only once)_

```zsh
# =========================
# NVM (Node Version Manager)
# =========================
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

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
# Git aliases
# =========================
alias gco="git checkout"
alias gcm="git commit -m"
alias gaa="git add ."
alias gs="git status -sb"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# =========================
# General aliases
# =========================
alias ls="eza --icons --group-directories-first"

# =========================
# Zsh plugins (lightweight)
# =========================
# Autosuggestions from history (ghost text)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be last plugin)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =========================
# Starship prompt
# =========================
eval "$(starship init zsh)"

# =========================
# History prefix search with arrows
# Type a prefix, then use ↑ / ↓ to cycle matching history
# =========================
bindkey '^[[A' history-beginning-search-backward   # Up arrow
bindkey '^[[B' history-beginning-search-forward    # Down arrow
```

---

## 9. Useful keyboard shortcuts

### Navigation

- `Ctrl + A` → start of line
- `Ctrl + E` → end of line
- `Ctrl + L` → clear screen
- `Alt + ← / →` → move word

### History

- Prefix + ↑ → cycle history with same start
- `Ctrl + R` → fuzzy full-history search

### FZF

- `Ctrl + R` → fuzzy history
- `Ctrl + T` → fuzzy file picker
- `Alt + C` → fuzzy directory jump

---

## 10. Useful commands

```bash
eza             # better ls
eza -l          # long list
eza -T          # tree-like list
bat file        # pretty cat
rg "text"       # search text in folder
tree -L 2       # depth-limited tree
```

---

## 11. Restore everything later

To rebuild your terminal on a new Mac:

1. Install Homebrew
2. Install CLI tools
3. Install fonts
4. Copy `.zshrc`
5. Copy `~/.config/starship.toml`
6. Run fzf installer

Your environment will be identical.

---

# 🎉 End of Terminal Setup
