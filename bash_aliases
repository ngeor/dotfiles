# Bash
alias cls=clear
alias hexit='history -c && rm -f ~/.bash_history && exit'
alias ll='ls -la'

# Maven
alias sortpom='mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort'

# Git
alias gs='git status'

# print the default branch of the current git repository
function git-default() {
    local default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [ -z "$default" ]; then
        echo "master"
    else
        echo $default
    fi
}

# Deletes all branches merged into the specified branch (or the default branch if no branch is specified)
function git-bclean() {
    local default=$(git-default)
    for branch in $(git branch --merged $default | grep -v " ${default}$"); do
        git branch -d $branch
    done
}

# Switches to specified branch (or the dafult branch if no branch is specified), runs git up, then runs bclean.
function git-bdone() {
    local default=$(git-default)
    git checkout $default && git up && git-bclean
}

# wipe out everything and get master
function git-nuke() {
    git reset HEAD --hard && git clean -dfx && git-bdone
}

# prints the most recent tag
function git-latest-tag() {
    git tag --sort=version:refname | tail -n 1
}

# prints the changes since the last tag
function git-log-since-tag() {
    git log $(git-latest-tag)..$(git-default)
}
