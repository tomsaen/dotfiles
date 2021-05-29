## zsh
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="${HOME}/.zsh_history"

## zplugin
source ~/.zplugin/bin/zplugin.zsh

zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin snippet OMZ::plugins/pip/pip.plugin.zsh
zplugin snippet OMZ::lib/completion.zsh 

# zplugin ice pick"async.zsh" src"pure.zsh"
# zplugin light sindresorhus/pure

autoload -Uz compinit
compinit

ZSH_BASE="${HOME}/.zsh"

export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export WINIT_HIDPI_FACTOR=1.0

# Virtualenv
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
# export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv
# export WORKON_HOME=~/.virtualenvs

if [ -f /usr/bin/virtualenvwrapper_lazy.sh ]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

## Load functions
fpath=(${fpath} ${ZSH_BASE}/zfuncs)
for func in ${ZSH_BASE}/zfuncs/*; do
    autoload -Uz $(basename ${func})
done

## Source aliases
for alias in ${ZSH_BASE}/alias/*; do
    source "$alias"
done

## NVM (if installed)
if [ -f /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
fi

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
CARGOPATH="${HOME}/.cargo/bin"
PIPPATH="${HOME}/.local/bin"

path+=(${GOPATH} ${GOBIN} ${CARGOPATH} ${PIPPATH} "$(ruby -e 'puts Gem.user_dir')/bin")

export PATH

export EDITOR=vim
export GPG_TTY=$(tty)

# Use emacs key-bindings to ensure, reverse-i-search within tmux is working
bindkey -e

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

alias zshsource="source ${HOME}/.zshrc"
alias zshedit="vim ${HOME}/.zshrc"
alias i3edit="vim ${HOME}/.config/i3/config"

## Make gnome keyring work
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start --components=ssh)
    export SSH_AUTH_SOCK
fi

## Starship
eval "$(starship init zsh)"
