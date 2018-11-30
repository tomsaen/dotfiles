## zsh
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="${HOME}/.zsh_history"

## zplug
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
fi

source "${HOME}/.zplug/init.zsh"

zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:2
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
# zplug denysdovhan/spaceship-zsh-theme, use:spaceship.zsh, from:github, as:theme
zplug load

if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

ZSH_BASE="${HOME}/.zsh"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

GOPATH="${HOME}/go"
CARGOPATH="${HOME}/.cargo/bin"
PIPPATH="${HOME}/.local/bin"

path+=(${GOPATH} "${GOPATH}/bin" ${CARGOPATH} ${PIPPATH})

export PATH

export EDITOR=vim
export GPG_TTY=$(tty)

alias zshsource="source ${HOME}/.zshrc"
alias zshedit="vim ${HOME}/.zshrc"
alias i3edit="vim ${HOME}/.config/i3/config"

## Make gnome keyring work
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
