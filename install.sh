#!/bin/bash -eu

# Ours variables
DIR="$(cd "$(dirname "$0")"; pwd)"
ZDIR="${DIR}/zsh"
VIMDIR="${DIR}/vim"
NVIMDIR="${DIR}/nvim"
TMUXDIR="${DIR}/tmux"
readonly DIR ZDIR VIMDIR NVIMDIR TMUXDIR

# Theirs variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

has() {
    command -v "$1" > /dev/null 2>&1
}

ask() {
    while true; do
        read -p "$1 ([y]/n) " -r
        REPLY=${REPLY:-"n"}
        if expr "$REPLY" : '^[Yy]$' >/dev/null; then
            return 0
        elif expr "$REPLY" : '^[Nn]$' >/dev/null; then
            return 1
        fi
    done
}

symlink() {
    src=$1
    dst=$2
    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            echo "$dst is already linked. Skipping ..."
            return 0
        fi
        ask "$dst already exists. Are you sure to overwrite it?" || return 0
        unlink "$dst"
    elif [[ -d "$dst" ]]; then
        echo "$dst is a real directory, not a symlink. Remove it manually and rerun. Skipping ..."
        return 0
    elif [[ -e "$dst" ]]; then
        ask "$dst already exists. Are you sure to overwrite it?" || return 0
        rm -f "$dst"
    fi
    ln -s "$src" "$dst"
}

main() {
  # zsh dotfiles
  echo "Making symbolic links to zsh files..."
  symlink "${ZDIR}"/zshrc "${ZDOTDIR:-$HOME}"/.zshrc
  symlink "${ZDIR}"/zsh_aliases "${ZDOTDIR:-$HOME}"/.zsh_aliases
  echo 'done.'
  echo

  # NeoVim
  echo "Making symbolic links to vim config files..."
  if has nvim; then
      [[ -d "${XDG_CONFIG_HOME}" ]] || mkdir -p "${XDG_CONFIG_HOME}"
      symlink "${NVIMDIR}" "${XDG_CONFIG_HOME}/nvim"
  fi
  if has vim > /dev/null; then
      symlink "${VIMDIR}/init.vim" "${HOME}/.vimrc"
      symlink "${VIMDIR}/vim.d" "${HOME}/vim.d"
  fi
  echo 'done.'
  echo

  # TMUX
  echo "Making symbolic links to tmux config files..."
  has tmux && symlink "${TMUXDIR}/tmux.conf" "${HOME}/.tmux.conf"
  has tmux && symlink "${TMUXDIR}/tmux.conf.local" "${HOME}/.tmux.conf.local"
  echo 'done.'
  echo
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
