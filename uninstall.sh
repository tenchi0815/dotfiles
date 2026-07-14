#!/bin/sh -eu

# Ours variables
readonly DIR="$(cd $(dirname $0); pwd)"
readonly ZDIR="$DIR/zsh"
readonly VIMDIR="$DIR/vim"

# Theirs variables
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

unlink_ifexist() {
    dst=$1
    [ -L "$dst" ] && unlink "$dst"
}

unlink_ifexist "${ZDOTDIR:-$HOME}"/.zprofile
unlink_ifexist "${ZDOTDIR:-$HOME}"/.zshenv
unlink_ifexist "${ZDOTDIR:-$HOME}"/.zshrc
unlink_ifexist "${ZDOTDIR:-$HOME}"/.zsh_aliases

# Delete symlink for NeoVim
unlink_ifexist "$XDG_CONFIG_HOME/nvim"

# Delete symlink for Vim
unlink_ifexist "$HOME"/.vimrc
unlink_ifexist "$HOME"/vim.d

# Delete symlinks for tmux
unlink_ifexist "$HOME"/.tmux.conf
unlink_ifexist "$HOME"/.tmux.conf.local

