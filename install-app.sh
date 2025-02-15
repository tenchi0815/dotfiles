#!/bin/bash -u

CMDNAME="$(basename "$0")"
DIRNAME="$(cd "$(dirname "$0")"; pwd)"
shells="bash zsh"
readonly CMDNAME DIRNAME shells
essentials=(git curl less jq make unzip xsel)
DRYRUN=
prefix=
update_config=2
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"${HOME}/.config/"}

cd "$HOME"
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
    if [[ -n "${DRYRUN}" ]]; then
        echo -e "${DRYRUN}$(quote_each_args "$@")"
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

while [[ $# -gt 0 ]]; do
    case $1 in
        -C|--dry-run)
            DRYRUN="[DRY-RUN] "
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

append_line() {
    local update line file pat lines
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"
    lines=""

    echo "..."
    echo "Update $file:"
    echo "  - $line"
    if [ -f "$file" ]; then
        if [ $# -lt 4 ]; then
            lines=$(\grep -nF "$line" "$file")
        else
            lines=$(\grep -nF "$pat" "$file")
        fi
    fi

    if [ -n "$lines" ]; then
        echo "    - Already exists:"
        sed 's/^/        Line /' <<< "$lines"

        update=0
        if ! \grep -qv "^[0-9]*:[[:space:]]*#" <<< "$lines" ; then
            echo "    - But they all seem to be commented"
            ask  "    - Continue modifying $file?"
            update=$?
        fi
    fi

    if [ "$update" -eq 1 ]; then
        [ -f "$file" ] && echo >> "$file"
        echo "$line" >> "$file"
        echo "    + Added"
    else
        echo "    ~ Skipped"
    fi

    echo
}

append_lines() {
    local update lines_to_add file pat lines
    update="$1"
    file="$2"
    pat="${3:-}"
    shift 3
    lines_to_add=("$@")
    lines=""

    echo "..."
    echo "Update $file:"

    if [ -f "$file" ]; then
        for line in "${lines_to_add[@]}"; do
            echo "  - $line"
            if [ -z "$pat" ]; then
                lines=$(\grep -nxF "$line" "$file")
            else
                lines=$(\grep -nxF "$pat" "$file")
            fi

            if [ -n "$lines" ]; then
                echo "    - Already exists:"
                sed 's/^/        Line /' <<< "$lines"

                update=0
            fi

            if [ "$update" -eq 1 ]; then
                echo "$line" >> "$file"
                echo "    + Added"
            else
                echo "    ~ Skipped"
            fi
        done
    else
        for line in "${lines_to_add[@]}"; do
            echo "$line" >> "$file"
            echo "    + Added"
        done
    fi
    [ "$update" -eq 1 ] && echo >> "$file"      # Add blank line at the end of file if $update is 1
}

append_config () {
    for shell in $shells; do
        if [ "$shell" = zsh ]; then
            dest=${HOME}/.zshrc.local
            [ ! -e "$dest" ] && dest=${ZDOTDIR:-$HOME}/.zshrc
        else
            dest=~/.bashrc
            append_line $update_config "[ -f ${prefix}.${shell} ] && source ${prefix}.${shell}" "$dest" "${prefix}.${shell}"
        fi
    done
}

# Get system info
uname_s="$(uname -s)"
uname_m="$(uname -m)"
case "$uname_s" in
    Darwin)             os="macos"  ;;
    Linux)              os="linux"  ;;
    CYGWIN*\ *64)       os="windows"    ;;
    MINGW*\ *64)        os="windows"    ;;
    MSYS*\ *64)         os="windows"    ;;
    Windows*\ *64)      os="windows"    ;;
    *)                  os="$uname_s"   ;;
esac
echo "Your operating system is \"$os\" on \"$uname_m\" architecture"
echo

# Detect the package manager and install essential packages.
if ask "Do you want to install essential packages?"; then
    if has apt; then
        echo "Detected apt package manager"
        pkg_mgr='apt'
        echo '>>> Essentials'
        run sudo "${pkg_mgr}" update
        run sudo "${pkg_mgr}" install -y "${essentials[@]}" shellcheck
    elif has dnf; then
        echo "Detected dnf package manager"
        pkg_mgr='dnf'
        echo '>>> Essentials'
        run sudo "${pkg_mgr}" update
        run sudo "${pkg_mgr}" install -y "${essentials[@]}" ShellCheck
    elif has yum; then
        echo "Detected yum package manager"
        pkg_mgr='yum'
        echo '>>> Essentials'
        run sudo "${pkg_mgr}" update
        run sudo "${pkg_mgr}" install -y "${essentials[@]}" ShellCheck
    else
        errExit "No compatible package manager found."
    fi
fi
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
        [[ "$uname_s" == "windows" ]] && binary_available=0
        case "$uname_m" in
            arm64)      archi="arm64"  ;;
            x86_64)     archi="x86_64"  ;;
            armv8*)     archi="arm64"   ;;
            aarch64*)   archi="arm64"  ;;
            *64)        archi="x86_64"   ;;
            *)          binary_error=1   ;;
        esac
        if [ -n "$binary_error" ]; then
            if [ $binary_available -eq 0 ]; then
                echo "Prebuilt binary for $uname_s is available. Install manually from https://github.com/neovim/neovim/releases"
            else
                echo "No prebuilt binary for $uname_s ..."
                echo "Neovim may not suport $uname_s platform."
            fi
        else
            echo "Downloading nvim ..."
            nvim_base="nvim-${os}-${archi}"
            if [ -x /opt/"$nvim_base"/bin/nvim ]; then
                echo "  - Already exists"
            else
                run curl -LO "https://github.com/neovim/neovim/releases/download/v0.10.4/${nvim_base}.tar.gz"
                run sudo rm -rf /opt/nvim
                run sudo tar -C /opt -xzf nvim-"${os}"-"${archi}".tar.gz
            fi
            #echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
            echo
        fi

        if ask "Do you want to update your shell configuration files?"; then
            update_config=1
            for shell in $shells; do
                prefix="${DIRNAME}/nvim/.nvim"
                src=${prefix}.${shell}
                echo -n "Generate $src ... "

                cat > "$src" << EOF
# Setup Neovim
# -------------------------------------------------------------------------------------------------------
PATH="\${PATH:+\${PATH}:}/opt/$nvim_base/bin"
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'

EOF
                echo "OK"
                if [ "$shell" = 'zsh' ]; then
                    dest=${HOME}/.zshrc.local
                    [ ! -e "$dest" ] && dest=${ZDOTDIR:-$HOME}/.zshrc
                else
                    dest=~/.bash_profile # if .zshrc.local
                fi
                append_line $update_config "[ -f $src ] && source $src" "$dest" "$src"
            done
        fi
	[ -d "${XDG_CONFIG_HOME}/nvim" ] || mkdir -p "${XDG_CONFIG_HOME}/nvim"
    fi
    msg_done "Neovim"
fi
echo

# zsh-git-escape-magic
echo '>>> zsh-git-escape-magic'
if has zsh; then
    if has git-escape-magic; then
        msg_already "git-escape-magic"
    else
        has git || { echo "git is not found. Install git first."; :; }
        msg_inprogress "git-escape-magic"
        if [[ ! -f /usr/share/zsh/functions/Zle/git-escape-magic ]]; then
            run git clone https://github.com/knu/zsh-git-escape-magic.git
            run sudo mv zsh-git-escape-magic /usr/share/zsh/functions/Zle/
            run sudo ln -s /usr/share/zsh/functions/Zle/zsh-git-escape-magic/git-escape-magic /usr/share/zsh/functions/Zle/git-escape-magic
            msg_done "git-escape-magic"
        else
            msg_already "git-escape-magic"
        fi
        if ask "Do you want to update your shell configuration files?"; then
            update_config=1
            # Lines to be added
            lines=(
                "# Setup git-escape-magic"
                "# -------------------------------------------------------------------------------------------------------"
                "autoload -Uz git-escape-magic"
                "git-escape-magic"
            )
            if has zsh; then
                dest=${HOME}/.zshrc.local
                [ ! -e "$dest" ] && dest=${ZDOTDIR:-$HOME}/.zshrc
                append_lines $update_config "$dest" "" "${lines[@]}"
                #while read line; do echo $line; done <<< $lines
            else
                echo "Nothing to do"
            fi
        fi
    fi
fi
echo

# vim-plug
echo '>>> vim-plug'
if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]] ||  [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]]; then
    msg_already "vim-plug"
else
    if ask "Do you want to install vim-plug?"; then
        if has nvim; then
            [[ "$(uname -s)" == "Linux" ]] && run sh -c "curl -fLoq ${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
                || echo "Thix script does not suport platform $(uname -s). Install manually."
        elif has vim; then
            [[ "$(uname -s)" == "Linux" ]] && run curl -fLoq ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
                || echo "Thix script does not suport platform $(uname -s). Install manually."
        else
            echo "Neither nvim nor vim is installed."
        fi
    fi
fi
echo

# deno
echo '>>> deno'
if has deno; then
    msg_already "deno"
else
    if ask "Do you want to install Deno?"; then
        if [ -x "${DENO_INSTALL:-$HOME/.deno}/bin/deno" ]; then
            echo "  - Already exists"
        else
            run curl -fsSL https://deno.land/install.sh | run sh
        fi
    fi
fi
echo

# kubectl
echo '>>> kubectl'
if has kubectl; then
    msg_already "kubectl"
else
    if ask "Do you want to install kubectl?"; then
        case "$uname_m" in
            arm64)      archi="arm64"  ;;
            x86_64)     archi="amd64"  ;;
            armv8*)     archi="arm64"   ;;
            aarch64*)   archi="arm64"  ;;
            *64)        archi="amd64"   ;;
            *)          binary_error=1   ;;
        esac
        [[ "$os" == "macos" ]] && os="darwin"
        run curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${os}/${archi}/kubectl"
        run curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${os}/${archi}/kubectl.sha256"
        echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check || exit 1
        rm kubectl.sha256

        if [[ "$os" == "darwin" ]]; then
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl
            sudo chown root: /usr/local/bin/kubectl
        elif [[ "$os" == "linux" ]]; then
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        fi
    fi
fi
echo
echo '  >>> kubectl completion'
if ask "Do you want to update your shell configuration files?"; then
    update_config=1
    for shell in $shells; do
        if [ "$shell" = 'zsh' ]; then
            dest=${HOME}/.zshrc.local
            [ ! -e "$dest" ] && dest=${ZDOTDIR:-$HOME}/.zshrc
        elif [ "$shell" = 'bash' ]; then
            dest=~/.bashrc
        fi
        append_line $update_config "source <(kubectl completion $shell)" "$dest" "$src"
    done
fi
echo 'done.'
