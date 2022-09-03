# Git
alias gs='git status'

# Bash
alias hexit='history -c && rm -f ~/.bash_history && exit'

# Maven
alias sortpom='mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort'
alias syncpom='mvn yak4j-sync-archetype:sync@sync'

# clang-format
alias clang-format-java='find . -type f -name "*.java" -exec clang-format -i {} \;'

# npm version
alias npm-bump='npm version --no-git-tag-version'

# poor man's HTTP monitoring
function pingdom() {
  while true; do curl -I $1; sleep 2; done
}

# build and install archetype
alias archmake='mvn clean install archetype:update-local-catalog'

alias cls=clear
alias ll='ls -la'

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
