export NVM_DIR="$HOME/.config/nvm"
export PATH=$HOME/.config/rofi/scripts:$PATH
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

case $(uname -n) in
    "LAPTOP-9LSO5HH7" | "dylan-thonkpad")
        zsh_add_file "zsh-work"
        ;;
    *)
        export TERMINAL="alacritty"

        # Speedy keys
        xset r rate 210 40
        setxkbmap -option ctrl:nocaps
        ;;
esac

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

# eval "`dircolors ~/.config/dircolors`"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload edit-command-line; zle -N edit-command-line

[[ -t 0 && $- = *i* ]] && stty -ixon

if [ -x "$(command -v tmux)" ] && [ -x "$(command -v tmux-sessionizer)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    tmux attach || tmux-sessionizer ~ >/dev/null 2>&1
fi

eval "$(starship init zsh)"
