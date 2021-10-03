#!/bin/bash
set -eo pipefail

function print_help() {
    cat << END
$0 juggles between monorepo and multirepo setups

Parameters:

-h, --help:
     Prints this help information.
-u, --user:
    The GitHub username, if needed to create a repository.
-t, --token:
    The GitHub token, if needed to create a repository.
-a, --action:
    Selects the action to perform. Possible options are:
        folder-to-folder: Moves from the folder of one repo
                          to the folder of another repo.
        folder-to-repo:   Moves from the folder of one repo
                          to a new repo.
-sr, --source-repo:
    The source repository. Can be a folder or URL (something to clone from).
-sf, --source-folder:
    The subfolder to extract from the source repository.
-d, --dest:
    The name of the destination repo.
    For the folder-to-repo action, this is the path to the folder
    where the repo should be cloned. The last element of the path
    is the repo name.
    Example: -d /my/projects/new-project
--default-branch-name:
    The name of the default branch for new repositories.
    Default value is "main".
END
}

function parse_args() {
    default_branch_name="main"
    while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
        -h | --help )
            print_help
            exit
            ;;
        -u | --user )
            shift
            if [[ -z "$1" ]]; then
                echo "Username not specified"
                exit 1
            fi
            user=$1
            ;;
        -t | --token )
            shift
            if [[ -z "$1" ]]; then
                echo "Token not specified"
                exit 1
            fi
            token=$1
            ;;
        -a | --action )
            shift
            if [[ -z "$1" ]]; then
                echo "Action not specified"
                exit 1
            fi
            action=$1
            ;;
        -sr | --source-repo )
            shift
            if [[ -z "$1" ]]; then
                echo "Source repo not specified"
                exit 1
            fi
            source_repo=$1
            ;;
        -sf | --source-folder )
            shift
            if [[ -z "$1" ]]; then
                echo "Source folder not specified"
                exit 1
            fi
            source_folder=$1
            ;;
        -d | --dest )
            shift
            if [[ -z "$1" ]]; then
                echo "Destination not specified"
                exit 1
            fi
            dest=$1
            ;;
        --default-branch-name )
            shift
            if [[ -z "$1" ]]; then
                echo "Default branch name not specified"
                exit 1
            fi
            default_branch_name=$1
            ;;
    esac; shift; done
    if [[ "$1" == "--" ]]; then shift; fi
}

function run_action() {
    if [[ -z "$action" ]]; then
        echo "Please specify the action to perform with the -a parameter."
        exit 1
    fi
    if [[ "$action" == "folder-to-folder" ]]; then
        folder_to_folder
    elif [[ "$action" == "folder-to-repo" ]]; then
        folder_to_repo
    else
        echo "Unsupported action: $action"
        exit 1
    fi
}

function folder_to_folder() {
    echo "edit the script before running anything"
    exit 1
    OLD_REPO=kamino
    NEW_REPO=python

    for p in bclean chm-helper delete-old-tweets git-analyze kddbot version-ci-bot wpbot
    do

        pushd $OLD_REPO
        git branch -D temp || true
        git subtree split -P $p/ -b temp
        popd

        pushd $NEW_REPO
        git subtree add -P apps/$p ../$OLD_REPO/ temp
        popd

        pushd $OLD_REPO
        git branch -D temp || true
        git rm -rf $p/
        git commit -m "Migrated $p to new repo"
        popd

    done
}

function folder_to_repo() {
    if [[ -z "$user" ]]; then
        echo "GitHub user is required"
        exit 1
    fi
    if [[ -z "$token" ]]; then
        echo "GitHub token is required"
        exit 1
    fi
    if [[ -z "$source_repo" ]]; then
        echo "Source repo is required"
        exit 1
    fi
    if [[ -z "$source_folder" ]]; then
        echo "Source folder is required"
        exit 1
    fi
    if [[ -z "$dest" ]]; then
        echo "Destination repo is required"
        exit 1
    fi
    local dest_name="$(basename $dest)"
    if [[ -z "$dest_name" ]]; then
        echo "Could not determine destination name from $dest"
        exit 1
    fi
    if [[ -z "$default_branch_name" ]]; then
        echo "Default branch name is required"
        exit 1
    fi

    local temp_source="$TMP/temp-source"
    echo "[1] Cloning $source_repo into $temp_source"
    rm -rf $temp_source
    git clone $source_repo $temp_source

    local temp_bare_dest="$TMP/temp-bare-dest"
    echo "[2] Preparing new empty bare repo in $temp_bare_dest"
    rm -rf $temp_bare_dest
    git init --bare $temp_bare_dest
    pushd $temp_bare_dest
    git symbolic-ref HEAD refs/heads/$default_branch_name
    popd

    echo "[3] Pushing sub folder $source_folder to new repo"
    pushd $temp_source
    git subtree push -P $source_folder $temp_bare_dest $default_branch_name
    popd

    local temp_dest="$TMP/temp-dest"
    echo "[4] Cloning bare dest into regular dest $temp_dest"
    rm -rf $temp_dest
    git clone $temp_bare_dest $temp_dest

    echo "[5] Creating repository in GitHub"
    curl -X POST -u $user:$token \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos -d "{ \"name\": \"${dest_name}\" }"

    echo "[6] Pushing to GitHub"
    local remote_name="github"
    local clone_url="git@github.com:$user/$dest_name.git"
    pushd $temp_dest
    git remote add $remote_name $clone_url
    git push $remote_name $default_branch_name
    popd

    echo "[7] Cloning from GitHub"
    git clone $clone_url $dest
}

parse_args $*
run_action
