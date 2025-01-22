# /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#
if [ "$SHLVL" = "1" ] && [ ! -z "$PS1" ] ; then
    [ -d ~/log/ ] || mkdir ~/log
    find ~/log/ -type f -mtime +60 -delete
    script -fq >(awk '{print strftime("%FT%T%z ") $0}{fflush() }'>> $HOME/log/"$(date +%Y%m%d_%H%M%S)_wsl.log")
fi

# Automatic dynamic port-forward to hopgate
process_name="/usr/local/bin/hopgate-portforward"
if [ -f $process_name ] && [ ! -z `pgrep -P 1 -f "$process_name"` ]; then
	/usr/local/bin/hopgate-portforward > /dev/null
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
