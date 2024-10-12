# dotfiles

dotfiles and small scripts

## Installation on Windows

- Clone the repository
- Open a Command Prompt as Administrator
- From the repository folder, run `install.cmd up`
- To uninstall, run `install.cmd down`

## Git aliases

Include this in your own `.gitconfig` by using the `[include]` directive with the path to this file

```
[include]
    path = ~/.gitconfig_include
```

If you don't have any existing includes, you can add this via the following command

```
git config --global include.path ~/.gitconfig_include
```

## PowerShell aliases

Add this line to `$Home\Documents\WindowsPowerShell\Profile.ps1`:

```
. "path-to-the-repository\aliases.ps1"
```

## VSCode settings

The `vscode` folder contains settings and keybindings.
The `install.cmd` script will automatically link them
to your VS Code User folder.

## Customized Git Bash prompt

The `git-prompt.sh` file offers a customized Git Bash
prompt for Git Bash on Windows.
The `install.cmd` script will automatically link it
under `$HOME/.config/git`.

## VIM settings

The `vimrc` file contains VIM settings.

## Apple keybindings

Workaround taken from [here](https://discussions.apple.com/thread/251108215?sortBy=best)
to fix the behavior of Home and End keys so that they match
the standard Windows behavior. The file is in `DefaultKeyBinding.dict`
and it gets linked to `~/Library/KeyBindings/DefaultKeyBinding.dict`.
