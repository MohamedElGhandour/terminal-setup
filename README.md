# 🚀 My Terminal Setup (2026)

A complete guide to reconstructing my macOS terminal environment from scratch.
This setup includes:

- Zsh configuration
- Plugins & enhancements
- Fonts with icons
- FZF fuzzy finder
- Starship prompt (Pure preset)
- Essential CLI tools

Optimized for speed, clarity, and minimal configuration.

---

# 📚 Table of Contents

1. Install Homebrew
2. Install CLI Tools
3. Configure & Install NVM + Node
4. Install Zsh Plugins
5. Install Starship Prompt
6. Enable FZF Integrations
7. Install Nerd Font
8. Final .zshrc
9. Keyboard Shortcuts
10. Common Commands
11. How to Restore on a New Mac
12. Queue Heavy Commit Checks (Husky)

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

### Included tools

| Tool    | Purpose              |
| ------- | -------------------- |
| git     | version control      |
| wget    | HTTP downloads       |
| tree    | directory tree       |
| fzf     | fuzzy search         |
| jq      | JSON parser          |
| bat     | pretty cat           |
| eza     | modern ls            |
| ripgrep | fast search          |
| nvm     | Node version manager |

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

Enable:

- auto-completion
- key bindings
- shell integration

---

## 7. Install Nerd Font

```bash
brew install --cask font-meslo-lg-nerd-font
```

Set MesloLGS Nerd Font in your terminal.

---

## 8. Final .zshrc configuration

My exact, current file is [`zsh/.zshrc`](zsh/.zshrc). Install it with:

```bash
cp zsh/.zshrc ~/.zshrc
source ~/.zshrc
```

It is the same as the block below.

```bash
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

```

---

## 9. Useful keyboard shortcuts

### Navigation

- Ctrl + A → start of line
- Ctrl + E → end of line
- Ctrl + L → clear screen
- Alt + ← / → → move by word

### History

- Prefix + ↑ → search history
- Ctrl + R → fuzzy history

### FZF

- Ctrl + R → fuzzy history
- Ctrl + T → fuzzy file picker
- Alt + C → fuzzy cd

---

## 10. Useful commands

```bash
eza             # better ls
eza -l          # long list
eza -T          # tree view
bat file        # pretty cat
rg "text"       # search text fast
tree -L 2       # tree depth 2
```

---

## 11. Restore everything later

1. Install Homebrew
2. Install CLI tools
3. Install fonts
4. Copy `zsh/.zshrc` to `~/.zshrc`
5. Copy starship.toml
6. Run FZF installer
7. Copy `husky/init.sh` to `~/.config/husky/init.sh`

---

## 12. Queue heavy commit checks (Husky)

### What is this?

**Husky** is a tool the `citiesapps/web` project uses to run checks every time a git commit is made: formatting, lint and unit tests. If a check fails, the commit is refused.

Husky also lets each developer add a **personal** script that runs right before those checks: `~/.config/husky/init.sh`. It lives only on your own Mac, it is not part of any project, and nobody else gets it. [`husky/init.sh`](husky/init.sh) in this repo is my copy of that file.

### Why do I need it?

Most commits only run the few tests linked to the changed files, which takes seconds. Some files can't be linked to specific tests: lint rules, design-token styles, test settings, deleted files. For those, the commit check runs **all** unit tests of the affected apps, which keeps about a dozen test processes busy.

I often run several AI sessions at once (Claude, Codex), each in its own worktree (a separate folder of the same repository). When two of them made such a commit at the same time, both big test runs went side by side. On 2026-10-20 that used 46 test processes and 6 to 8.6 GB of RAM for more than an hour.

### What it does

Only in `citiesapps/web`, and only for those heavy commits:

1. **Take turns.** If another worktree is already running its big tests, the commit waits and prints who it is waiting for:

   ```
   Waiting for the full unit suites another worktree is running (pid 12345, /path/to/that/worktree).
   ```

   It starts as soon as the other one is done. Don't cancel a commit that shows this line; it is waiting, not stuck.

2. **One app at a time.** The apps of one commit are tested one after another (`NX_PARALLEL=1`) instead of up to eight at once.

```
Before:  Session A  big tests ████████████
         Session B  big tests ████████████              both at once, double memory

After:   Session A  big tests ████████████
         Session B  waits...               ████████████  one at a time
```

Everything else stays the same: normal commits never wait, other repositories are ignored, and teammates are not affected.

### How it works

- It asks the project's own commit-check code (`scripts/husky/unit-test-args.mjs`) whether this commit needs the full tests, so it always agrees with the real check.
- The "turn" is a small lock file, `commit-gate-unit-suites.lock`, in the repository's shared `.git` folder. All worktrees of one clone use that same folder, so all sessions share one queue.
- The lock file holds the process id of the commit that has the turn. If that process is gone (a crashed or killed session), the next commit removes the lock and goes ahead, so the queue never gets stuck.
- The lock is removed when the commit check finishes, whether the check passes or fails.

### Install

```bash
mkdir -p ~/.config/husky
cp husky/init.sh ~/.config/husky/init.sh
```

### Check or remove

```bash
# Inside any citiesapps/web worktree: who has the turn right now (no file = nobody)
cat "$(git rev-parse --path-format=absolute --git-common-dir)/commit-gate-unit-suites.lock"

# Remove it
rm ~/.config/husky/init.sh
```

---

# 🎉 Setup Complete
