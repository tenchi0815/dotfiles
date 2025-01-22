#!/bin/sh -eu

# Ours variables
readonly DIR="$(cd $(dirname $0); pwd)"
readonly ZDIR="$DIR/zsh"
readonly VIMDIR="$DIR/vim"

# Theirs variables
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

has() {
    command -v "$1" > /dev/null 2>&1
}

symlink_dir() {
    src=$1
    dst=$2
    [ -L "$dst" ] && rm -fr "$dst"
    ln -sf "$src" "$dst"
}

#[ -d $XDG_CONFIG_HOME ] || mkdir -p $XDG_CONFIG_HOME
#ln -s $ZDIR $HOME/.config/zsh
ln -sf $ZDIR/.zprofile $HOME/.zprofile
ln -sf $ZDIR/.zshenv $HOME/.zshenv
ln -sf $ZDIR/.zshrc $HOME/.zshrc

# for NeoVim
if command -v nvim > /dev/null; then
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config/"}
    [ -d $XDG_CONFIG_HOME ] || mkdir -p $XDG_CONFIG_HOME
    ln -sf "$VIMDIR" "$XDG_CONFIG_HOME/nvim"
elif command -v vim > /dev/null; then
    ln -sf "$VIMDIR"/init.vim "$HOME"/.vimrc
    ln -sf "$VIMDIR"/vim.d "$HOME"/vim.d
else
    echo "Neither nvim nor vim is installed."
    exit 1
fi
