#!/bin/bash -eu

cd "$HOME"

CMDNAME="$(basename "$0")"
print_usage() {
  cat - << EOF
usage: ${CMDNAME} (-C|--dry-run)
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
    echo "${prefix}$1 is already installed."
}
msg_inprogress() {
    echo "${prefix}Installing $1 ..."
}
msg_done() {
    echo "${prefix}$1 sucessfully installed"
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

#set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

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
run sudo "${pkg_mgr}" update
echo

# zsh
echo '>>> zsh'
run sudo "${pkg_mgr}" install -y zsh
[[ $SHELL = '/bin/zsh' ]] || run chsh -s /bin/zsh
echo

# tmux
echo '>>> tmux'
run sudo "${pkg_mgr}" install -y tmux
echo

# fzf
echo '>>> fzf'
if has fzf
then
    msg_already "fzf"
else
    msg_inprogress "fzf"
    run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    run ~/.fzf/install && msg_done "fzf"
fi
echo

# Neovim
echo '>>> Neovim'
if has nvim
then
    msg_already "Neovim"
else
    run curl -LO "https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-"$(uname -p)".tar.gz"
    run sudo rm -rf /opt/nvim
    run sudo tar -C /opt -xzf nvim-linux-$(uname -p).tar.gz

    #echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
    msg_done "Neovim"
fi
echo

# zsh-git-escape-magic
echo '>>> zsh-git-escape-magic'
if [ -f /usr/share/zsh/functions/Zle/git-escape-magic ]
then
    msg_already "git-escape-magic"
else
    msg_inprogress "git-escape-magic"
    run git clone https://github.com/knu/zsh-git-escape-magic.git
    run sudo mv zsh-git-escape-magic /usr/share/zsh/functions/Zle/
    run sudo ln -s /usr/share/zsh/functions/Zle/zsh-git-escape-magic/git-escape-magic /usr/share/zsh/functions/Zle/git-escape-magic
    msg_done "git-escape-magic"
fi
echo

echo 'done.'
