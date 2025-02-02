#!/bin/sh -eu

# Ours variables
readonly DIR="$(cd "$(dirname "$0")"; pwd)"
readonly ZDIR="${DIR}/zsh"
readonly VIMDIR="${DIR}/vim"
readonly TMUXDIR="${DIR}/tmux"

# Theirs variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"

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
echo "Making symbolic links to zsh files..."
symlink_dir "${ZDIR}"/.zprofile "${ZDOTDIR:-~}"/.zprofile
symlink_dir "${ZDIR}"/.zshenv "${ZDOTDIR:-~}"/.zshenv
symlink_dir "${ZDIR}"/.zshrc "${ZDOTDIR:-~}"/.zshrc
symlink_dir "${ZDIR}"/.zsh_aliases "${ZDOTDIR:-~}"/.zsh_aliases

# NeoVim
echo "Making symbolic links to vim config files..."
if has nvim; then
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"${HOME}/.config/"}
    [ -d "${XDG_CONFIG_HOME}" ] || mkdir -p "${XDG_CONFIG_HOME}"
    symlink_dir "${VIMDIR}" "${XDG_CONFIG_HOME}/nvim"
elif has vim > /dev/null; then
    symlink_dir "${VIMDIR}"/init.vim "${HOME}"/.vimrc
    symlink_dir "${VIMDIR}"/vim.d "${HOME}"/vim.d
else
    echo "Neither nvim nor vim is installed."
    echo "Skipped."
fi

# TMUX
echo "Making symbolic links to tmux config files..."
has nvim && symlink_dir "${TMUXDIR}" "${HOME}/.tmux.conf"

echo 'Done'
