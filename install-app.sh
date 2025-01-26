#!/bin/zsh -eu

has() {
    command -v "$1" > /dev/null 2>&1
}

## Neovim
if has nvim
then
    echo "Neovim is already installed."
else
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    path+=('/opt/nvim-linux64/bin')
    export PATH

    #echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
    echo "Neovim downloaded and extracted."
fi

