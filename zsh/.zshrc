export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/scripts:$PATH
export PATH=$HOME/.local/go/bin:$PATH
export GOPATH=$HOME/.local/go
source "$ZDOTDIR/zsh-functions"

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
autoload -Uz compinit
compinit
_comp_options+=(globdots)		# Include hidden files.

zle_highlight=('paste:none')

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^p" up-line-or-beginning-search # Up
bindkey "^n" down-line-or-beginning-search # Down
bindkey "^k" up-line-or-beginning-search # Up
bindkey "^j" down-line-or-beginning-search # Down

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Environment variables set everywhere
export EDITOR="nvim"

zsh_add_file "zsh-local"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

[ -e ~/.config/dircolors ] && eval "`dircolors ~/.config/dircolors`"

autoload edit-command-line; zle -N edit-command-line

[[ -t 0 && $- = *i* ]] && stty -ixon

if [ -x "$(command -v tmux)" ] && [ -x "$(command -v tmux-sessionizer)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    tmux attach || tmux-sessionizer ~ >/dev/null 2>&1
fi

if [ -z "$SWAYSOCK" ] && [ -d "/run/user/$UID" ]; then
    export SWAYSOCK=$(ls /run/user/$UID/sway-ipc.*.sock 2>/dev/null | head -n 1)
fi

eval "$(starship init zsh)"
