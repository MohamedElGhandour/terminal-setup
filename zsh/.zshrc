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
alias gpl="git pull"
alias gpm="git pull --no-rebase"
alias gcm="git commit -m"
alias gad="git add ."
alias gaa="git add -A"
alias gs="git status -sb"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# Make alias completion behave like the real git subcommands
compdef gco=git-checkout 2>/dev/null || compdef gco=git
compdef gsw=git-switch   2>/dev/null || compdef gsw=git

# git fetch                      # Download remote changes, but do not merge them into your branch

# git diff                       # Show unstaged changes

# git diff --staged             # Show staged changes that will go into the next commit

# git restore <file>            # Discard unstaged changes in a file

# git restore .                 # Discard all unstaged changes

# git restore --staged <file>   # Unstage a file, keep its local changes

# git restore --staged .        # Unstage everything, keep local changes

# git clean -fd                 # Delete untracked files and folders, dangerous

# git branch                    # List local branches

# git branch -a                 # List local and remote branches

# git branch -d <branch>        # Delete a local branch safely

# git branch -D <branch>        # Force delete a local branch

# git switch -c <branch>        # Create and switch to a new branch

# git merge <branch>            # Merge another branch into current branch

# git rebase <branch>           # Replay your commits on top of another branch

# git stash                     # Save uncommitted changes temporarily

# git stash pop                 # Restore stashed changes and remove them from stash

# git remote -v                 # Show remote repositories

# git reset --soft HEAD~1       # Undo last commit, keep changes staged

# git reset HEAD~1              # Undo last commit, keep changes unstaged

# git revert <commit>           # Make a new commit that reverses an older commit

# git show <commit>             # Show details of a commit

# git blame <file>              # Show who changed each line in a file


# =========================
# General aliases
# =========================
alias ls="eza --icons --group-directories-first"

# =========================
# FZF integration
# =========================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =========================
# Zsh plugins (Homebrew)
# =========================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
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
export PATH="/Applications/WebStorm.app/Contents/MacOS:$PATH"
