## zsh
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="${HOME}/.zsh_history"

## zplug
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source "${HOME}/.zplug/init.zsh"

zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:2
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh
zplug denysdovhan/spaceship-zsh-theme, use:spaceship.zsh, from:github, as:theme
zplug load

if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Spaceship theme relevant things
SPACESHIP_BATTERY_SHOW=false
SPACESHIP_DOCKER_SHOW=false

ZSH_BASE="${HOME}/.zsh"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## Load functions
fpath=(${fpath} ${ZSH_BASE}/zfuncs)
for func in ${ZSH_BASE}/zfuncs/*; do
    autoload -Uz $(basename ${func})
done

## Source aliases
for alias in ${ZSH_BASE}/alias/*; do
    source "$alias"
done

## Source optional file within ZSH_BASE
optionals=("platform" "private")
for file in $optionals; do
    fullfile="${ZSH_BASE}/${file}"
    if [ -f $fullfile ]; then
      source $fullfile
    fi
done

path+=("${HOME}/.cargo/bin")
export PATH

export EDITOR=vim
export GPG_TTY=$(tty)

export WORKON_HOME=~/.virtualenvs

alias wakeup="wakeonlan -i 10.10.1.255 9c:b6:54:09:2e:2b"

alias zshsource="source ${HOME}/.zshrc"
alias zshedit="vim ${HOME}/.zshrc"
