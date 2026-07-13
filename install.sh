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
      XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"${HOME}/.config/"}
      [[ -d "${XDG_CONFIG_HOME}" ]] || mkdir -p "${XDG_CONFIG_HOME}"
      symlink "${NVIMDIR}/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
      symlink "${NVIMDIR}/lua" "${XDG_CONFIG_HOME}/nvim/lua"
      symlink "${NVIMDIR}/lsp" "${XDG_CONFIG_HOME}/nvim/lsp"
      symlink "${NVIMDIR}/nextword-data-small" "${XDG_CONFIG_HOME}/nvim/nextword-data-small"
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
