## zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/sudo
    zgen load zsh-users/zsh-syntax-highlighting

    zgen load denysdovhan/spaceship-zsh-theme spaceship
    zgen save
fi

ZSH_BASE="${HOME}/.zsh"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## Load functions
fpath=(${fpath} ${ZSH_BASE}/zfuncs)
for func in ${ZSH_BASE}/zfuncs/*; do
    autoload -Uz "{$func}"
done


## Load alias
for alias in ${ZSH_BASE}/alias/*; do
    source "$alias"
done


## Platform specific things
source "${ZSH_BASE}/platform"


path+=("${HOME}/.cargo/bin")
export PATH

export EDITOR=vim
export GPG_TTY=$(tty)

export WORKON_HOME=~/.virtualenvs

source <(gopass completion zsh)

alias wakeup="wakeonlan -i 10.10.1.255 9c:b6:54:09:2e:2b"
alias stylight-vpn="sudo openvpn --config ${HOME}/Documents/stylight.ovpn"

alias zshsource="source ${HOME}/.zshrc"
alias zshedit="vim ${HOME}/.zshrc"
