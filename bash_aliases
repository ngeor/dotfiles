#alias az='az.sh'
# GitFlow
alias gf-master='git checkout develop && git fetch -p -t && git pull'
alias gf-prune='gf-master && git branch --merged | grep -v master | grep -v develop | xargs git branch -d'

# GitHub Flow
alias ghf-master='git checkout master && git fetch -p -t && git pull'
alias ghf-prune='ghf-master && git branch --merged | grep -v master | xargs git branch -d'
alias ghf-prune-all='ghf-master && git branch -l | grep -v master | xargs git branch -D'

# Git
alias gs='git status'

# Bash
alias hexit='history -c && rm -f ~/.bash_history && exit'

# Localstack
alias lsns='aws --endpoint-url=http://localhost:4575 sns'
alias lsqs='aws --endpoint-url=http://localhost:4576 sqs'

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

# python make
alias pmake='pylint *.py && pylint tests/*.py && python -m pytest && coverage run -m pytest && coverage html && coverage report'

# build and install archetype
alias archmake='mvn clean install archetype:update-local-catalog'
