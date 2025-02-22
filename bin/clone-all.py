#!/usr/bin/env python3

import argparse
import os.path
import requests
import subprocess


def main():
    args = parse_args()
    if not os.path.isdir(args.directory):
        raise ValueError(
            f"Directory {args.directory} does not exist or is not a directory"
        )
    repos_generator = get_repos_generator(args.token, per_page=30)
    for repo in repos_generator:
        repo_dir = os.path.join(args.directory, repo["name"])
        if os.path.isdir(repo_dir):
            remote_default_branch = repo["default_branch"]
            local_default_branch = git_default_branch(repo_dir)
            if remote_default_branch != local_default_branch:
                print(
                    f"{repo['name']}: branch mismatch {local_default_branch} vs {remote_default_branch}"
                )
                fix_default_branch(
                    repo_dir, local_default_branch, remote_default_branch
                )
        else:
            print(f"{repo['name']} does not exist, cloning it")
            git_clone(repo["ssh_url"], args.directory)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--token", required=True)
    parser.add_argument("-d", "--directory", required=True)
    return parser.parse_args()


def get_repos_generator(token, per_page):
    has_more = True
    page = 1
    per_page = 30
    while has_more:
        repos = get_repos(token, page, per_page)
        has_more = len(repos) >= per_page
        page = page + 1
        for repo in repos:
            yield repo


def get_repos(token, page, per_page):
    response = requests.get(
        f"https://api.github.com/user/repos?affiliation=owner&page={page}&per_page={per_page}",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )
    response.raise_for_status()
    return response.json()


def git_clone(ssh_url, directory):
    git(["clone", ssh_url], cwd=directory)


def git_default_branch(directory):
    result = git(["symbolic-ref", "refs/remotes/origin/HEAD"], directory)
    return result.stdout.replace("refs/remotes/origin/", "").strip()


def fix_default_branch(directory, old_branch, new_branch):
    g = git_in_cwd(directory)
    g(["branch", "-m", old_branch, new_branch])
    g(["fetch", "origin"])
    g(["branch", "-u", f"origin/{new_branch}", new_branch])
    g(["remote", "set-head", "origin", "-a"])


def git(args, cwd):
    new_args = ["git"] + args
    return subprocess.run(
        new_args, cwd=cwd, encoding="utf-8", check=True, capture_output=True
    )


def git_in_cwd(cwd):
    def fn(args):
        return git(args, cwd)

    return fn


if __name__ == "__main__":
    main()
