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

# zsh dotfiles
#[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME
#ln -s $ZDIR $HOME/.config/zsh
echo "Making symbolic links to zsh files..."
symlink_dir $ZDIR/.zprofile $HOME/.zprofile
symlink_dir $ZDIR/.zshenv $HOME/.zshenv
symlink_dir $ZDIR/.zshrc $HOME/.zshrc
echo

# NeoVim
echo "Making symbolic links to vim config files..."
if has nvim; then
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config/"}
    [ -d $XDG_CONFIG_HOME ] || mkdir -p $XDG_CONFIG_HOME
    symlink_dir "$VIMDIR" "$XDG_CONFIG_HOME/nvim"
elif command -v vim > /dev/null; then
    symlink_dir "$VIMDIR"/init.vim "$HOME"/.vimrc
    symlink_dir "$VIMDIR"/vim.d "$HOME"/vim.d
else
    #echo "Neither nvim nor vim is installed."
    exit 1
fi
echo
