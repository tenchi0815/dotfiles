#!/bin/bash -eu

# Ours variables
DIR="$(cd "$(dirname "$0")"; pwd)"
ZDIR="${DIR}/zsh"
VIMDIR="${DIR}/nvim"
TMUXDIR="${DIR}/tmux"
readonly DIR ZDIR VIMDIR TMUXDIR

# Theirs variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

has() {
    command -v "$1" > /dev/null 2>&1
}

ask() {
    set +e
    while true; do
        read -p "$1 ([y]/n) " -r
        REPLY=${REPLY:-"n"}
        if expr "$REPLY" : '^[Yy]$' >/dev/null; then
            return 0
        elif expr "$REPLY" : '^[Nn]$' >/dev/null; then
            return 1
        fi
    done
    set -x
}

symlink() {
    src=$1
    dst=$2
    overwrite=0
    if [[ -e "$dst" ]]; then
        ask "$dst already exists. Are you sure to overwrite it?"
        overwrite=$?
    fi
    if [[ "$overwrite" == 0 ]]; then
        ln -sf "$src" "$dst"
    fi
}

# zsh dotfiles
echo "Making symbolic links to zsh files..."
symlink "${ZDIR}"/zprofile "${ZDOTDIR:-$HOME}"/.zprofile
symlink "${ZDIR}"/zshrc "${ZDOTDIR:-$HOME}"/.zshrc
symlink "${ZDIR}"/zshrc.local "${ZDOTDIR:-$HOME}"/.zshrc.local
symlink "${ZDIR}"/zsh_aliases "${ZDOTDIR:-$HOME}"/.zsh_aliases
echo 'done.'
echo

# NeoVim
echo "Making symbolic links to vim config files..."
if has nvim; then
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"${HOME}/.config/"}
    [[ -d "${XDG_CONFIG_HOME}" ]] || mkdir -p "${XDG_CONFIG_HOME}"
    symlink "${VIMDIR}/init.vim" "${XDG_CONFIG_HOME}/nvim/init.vim"
    symlink "${VIMDIR}/nvim.d" "${XDG_CONFIG_HOME}/nvim/nvim.d"
elif has vim > /dev/null; then
    symlink "${VIMDIR}/init.vim" "${HOME}/.vimrc"
    symlink "${VIMDIR}/nvim.d" "${HOME}/nvim.d"
else
    echo "Neither nvim nor vim is installed."
    echo "Skipped."
fi
echo 'done.'
echo

# TMUX
echo "Making symbolic links to tmux config files..."
has tmux && symlink "${TMUXDIR}/tmux.conf" "${HOME}/.tmux.conf"
echo 'done.'
echo
