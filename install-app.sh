#!/bin/bash -eu

cd "$HOME"

CMDNAME="$(basename "$0")"
print_usage() {
  cat - << EOF
usage: ${CMDNAME} [OPTIONS]
    -C, --dry-run
        Executes dry run mode; don't actually do anything, just show what will be done.
    -h, --help
        Show help
EOF
}

errExit() { echo "${1}"; exit "${2:-1}"; }

has() {
    command -v "$1" > /dev/null 2>&1
}

msg_already() {
    echo "$1 is already installed."
}
msg_inprogress() {
    echo "Installing $1 ..."
}
msg_done() {
    echo "$1 sucessfully installed"
}

run() {
  if "${DRYRUN}" ; then
    echo -e "${prefix}$(quote_each_args "$@")"
  else
    "$@"
    echo 'done.'
  fi
}

quote_each_args() {
  for i in $(seq 1 $#); do
    if [[ $i -lt $# ]]; then
      printf '%q ' "${!i}"
    else
      printf '%q' "${!i}"
    fi
  done
}

ask() {
  while true; do
    read -p "$1 ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 1
    fi
  done
}

download_nvim() {
local os="$1"
local archi="$2"
curl -LO "https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-$os-$archi.tar.gz"
}

DRYRUN=false
prefix=

while [[ $# -gt 0 ]]; do
  case $1 in
      -C|--dry-run)
          DRYRUN=true
          prefix="[DRY-RUN] "
          shift # past value
          ;;
      -h|--help)
          print_usage
          exit 0
          ;;
      -*)
          print_usage
          errExit "Unknown option: $1"
          ;;
      *)
          print_usage
          errExit "Unknown argument: $1"
          ;;
  esac
done

archi=$(uname -sm)

# Detect the package manager
if has apt; then
  echo "Detected apt package manager"
  pkg_mgr='apt'
elif has dnf; then
  echo "Detected dnf package manager"
  pkg_mgr='dnf'
elif has yum; then
  echo "Detected yum package manager"
  pkg_mgr='yum'
else
  errExit "No compatible package manager found."
fi
echo

# Update repogitories
echo '>>> Update package repo'
run sudo "${pkg_mgr}" update
echo

# Essentials
echo '>>> Essentials'
run sudo "${pkg_mgr}" install -y git curl less jq make
echo

# zsh
echo '>>> zsh'
if has zsh; then
    msg_already "zsh"
else
    if ask "Do you want to install zsh?"; then
        msg_inprogress "zsh"
        run sudo "${pkg_mgr}" install -y zsh
        ask "Do you want to set default shell to zsh?" && run chsh -s /bin/zsh
    fi
fi
echo

# tmux
echo '>>> tmux'
if has tmux; then
    msg_already "tmux"
else
    if ask "Do you want to install tmux?"; then
        msg_inprogress "tmux"
        run sudo "${pkg_mgr}" install -y tmux
    fi
fi
echo

# fzf
echo '>>> fzf'
if has fzf; then
    msg_already "fzf"
else
    if ask "Do you want to install fzf?"; then
        msg_inprogress "fzf"
        run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        run ~/.fzf/install && msg_done "fzf"
    fi
fi
echo

# Neovim
echo '>>> Neovim'
if has nvim; then
    msg_already "Neovim"
else
    if ask "Do you want to install Neovim?"; then
        msg_inprogress "Neovim"
        binary_available=1
        binary_error=""
        case "$archi" in
          Darwin\ arm64)      run download_nvim "macos" "arm64"  ;;
          Darwin\ x86_64)     run download_nvim "macos" "arm64"  ;;
          Linux\ armv5*)      binary_error=1   ;;
          Linux\ armv6*)      binary_error=1   ;;
          Linux\ armv7*)      binary_error=1   ;;
          Linux\ armv8*)      run download_nvim "linux" "arm64"   ;;
          Linux\ aarch64*)    run download_nvim "macos" "x86_64"  ;;
          Linux\ *64)         run download_nvim "macos" "x86_64"   ;;
          CYGWIN*\ *64)       binary_error=1 binary_available=0    ;;
          MINGW*\ *64)        binary_error=1 binary_available=0    ;;
          MSYS*\ *64)         binary_error=1 binary_available=0    ;;
          Windows*\ *64)      binary_error=1 binary_available=0    ;;
          *)                  binary_error=1   ;;
        esac
        if [ -n "$binary_error" ]; then
            if [ $binary_available -eq 0 ]; then
                echo "Prebuilt binary for $archi is available. Install manually from https://github.com/neovim/neovim/releases"
            else
                echo "No prebuilt binary for $archi ..."
                echo "Neovim may not suport $archi platform."
            fi
        else
            run sudo rm -rf /opt/nvim
            run sudo tar -C /opt -xzf nvim-"${os}"-"${archi}".tar.gz

            #echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
            msg_done "Neovim"
        fi
    fi
fi
echo

# zsh-git-escape-magic
echo '>>> zsh-git-escape-magic'
if [ -f /usr/share/zsh/functions/Zle/git-escape-magic ]; then
    msg_already "git-escape-magic"
else
    has zsh || { echo "zsh is not found. Install zsh first."; :; }
    has git || { echo "git is not found. Install git first."; :; }
    msg_inprogress "git-escape-magic"
    run git clone https://github.com/knu/zsh-git-escape-magic.git
    run sudo mv zsh-git-escape-magic /usr/share/zsh/functions/Zle/
    run sudo ln -s /usr/share/zsh/functions/Zle/zsh-git-escape-magic/git-escape-magic /usr/share/zsh/functions/Zle/git-escape-magic
    msg_done "git-escape-magic"
fi
echo

echo 'done.'
