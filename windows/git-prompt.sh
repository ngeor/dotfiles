# Customized version of the default git-prompt with
# the following adaptations:
# - Hide the username and the hostname
# - Keep the prompt on the same line as the git info
# - More information about the current status of the working directory
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
if test -z "$WINELOADERNOEXEC"
then
    GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
    COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
    COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
    COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
    if test -f "$COMPLETION_PATH/git-prompt.sh"
    then
        . "$COMPLETION_PATH/git-completion.bash"
        . "$COMPLETION_PATH/git-prompt.sh"
        PS1="$PS1"'\[\033[36m\]'  # change color to cyan

        GIT_PS1_SHOWCOLORHINTS="1"
        GIT_PS1_SHOWDIRTYSTATE="1"
        GIT_PS1_SHOWSTASHSTATE="1"
        GIT_PS1_SHOWUNTRACKEDFILES="1"
        GIT_PS1_SHOWUPSTREAM="verbose"

        PS1="$PS1"'`__git_ps1`'   # bash function
    fi
fi
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'$ '                 # prompt: always $
