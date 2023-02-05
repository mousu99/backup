#[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
#!/usr/bin/env zsh

#fpath=($DOTFILES/zsh/plugins $fpath)

# +------------+
# | NAVIGATION |
# +------------+

setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

#source $DOTFILES/zsh/plugins/bd.zsh

# +---------+
# | HISTORY |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# +------+
# | MISC |
# +------+

setopt NOBEEP              # Disable BEEP Sound

# +---------+
# | ALIASES |
# +---------+

source $ZDOTDIR/aliases.zsh

# +---------+
# | VI MODE |
# +---------+

bindkey -e

# +------------+
# | COMPLETION |
# +------------+
# autoload -U compinit; compinit

#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# +---------+
# | Plugins |
# +---------+
#plug "zsh-users/zsh-autosuggestions"
#plug "zsh-users/zsh-completions"
#plug "hlissner/zsh-autopair"
#plug "zap-zsh/supercharge"
##plug "zap-zsh/vim"
#plug "zsh-users/zsh-syntax-highlighting"
#plug "zsh-users/zsh-history-substring-search"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#eval "$(starship init zsh)"

#source $ZDOTDIR/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source $ZDOTDIR/nnn.zsh