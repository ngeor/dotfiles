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
