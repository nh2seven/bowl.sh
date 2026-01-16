# .bashrc

# Source global definitions -------------------------------------------------------------
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# PS1 -------------------------------------------------------------
# Colors
RESET="\[$(tput sgr0)\]"
WHITE="\[$(tput setaf 15)\]"
LIGHT_BLUE="\[$(tput setaf 44)\]"   # user
CYAN="\[$(tput setaf 38)\]"         # conda env
BEIGE="\[$(tput setaf 229)\]"       # @
GREEN="\[$(tput setaf 77)\]"        # host
LIME="\[$(tput setaf 154)\]"        # dir path

conda_prompt='$(if [ -n "$CONDA_DEFAULT_ENV" ]; then echo "$CONDA_DEFAULT_ENV"; fi)'
PS1=''$WHITE'┌─ \t '$BEIGE'| '$CYAN'\u'$BEIGE'@'$GREEN'\h'$BEIGE' | '$LIGHT_BLUE''$conda_prompt' '$WHITE'>\n└─ '$LIME'\w'$WHITE' \$ '$RESET''

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nh2seven/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nh2seven/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nh2seven/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nh2seven/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Aliases -------------------------------------------------------------
# Personal
alias gssh='ssh-add -D && ssh-add ~/.ssh/baz2seven && ssh-add -l'
alias gif='/home/nh2seven/Scripts/githuh.sh'

# Work
alias gai='ssh-add -D && ssh-add ~/.ssh/nion2seven && ssh-add -l'
alias gauto='/home/nh2seven/Scripts/nionfetch.sh'
alias gstamp='/home/nh2seven/Scripts/journal.sh'

# NVIDIA -------------------------------------------------------------
export PATH="/usr/local/cuda-13.0/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH"

# Zoxide -------------------------------------------------------------
export XDG_DATA_HOME="$HOME/.local/share"
export ZOXIDE_DB="$XDG_DATA_HOME/zoxide/db.zo"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
export _ZO_ECHO=0
export _ZO_EXCLUDE_DIRS="$HOME"
eval "$(zoxide init bash)"

# DuckDB -------------------------------------------------------------
export PATH='/home/nh2seven/.duckdb/cli/latest':$PATH

. "$HOME/.local/share/../bin/env"

# Composio CLI -------------------------------------------------------------
export COMPOSIO_INSTALL_DIR=$HOME/.composio
export PATH="$COMPOSIO_INSTALL_DIR:$PATH"
