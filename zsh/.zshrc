export PATH=$PATH:"$HOME/scripts"
export NVM_DIR="$HOME/.nvm"
# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
# zstyle ':completion::complete:lsof:*' menu yes select
# compinit
autoload -Uz compinit
compinit
_comp_options+=(globdots)		# Include hidden files.
source "$ZDOTDIR/zsh-functions"

zle_highlight=('paste:none')

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

autoload edit-command-line; zle -N edit-command-line
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
# Speedy keys
xset r rate 210 40

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"

[[ -t 0 && $- = *i* ]] && stty -ixon

eval "$(starship init zsh)"
