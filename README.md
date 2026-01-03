# dotfiles

dotfiles and small scripts

## Overview

Due to the differences between OSes, there are three top-level folders
that contain OS specific files: `linux`, `mac`, `windows`.

Note: the `windows` setup is not actively maintained at the moment.

## Common files

* `bin` contains small scripts that should run on all platforms. This directory
  should be added to the `PATH`.
* `gitconfig_include` and `vimrc` should also work on all systems

## Linux files

### Shell (bash)

* `bashrc` should be linked to `~/.bashrc`
* `aliases` should be linked to `~/.aliases`

### VS Code

* `keybindings.json` and `settings.json` should be linked to `~/.config/Code/User/`

Note that the snippets are currently in a different repo (and are OS-neutral).

## Mac files

### Shell (zsh)

* `zsh/zshrc` should be linked to `~/.zshrc`
* `zsh/aliases` should be linked to `~/.aliases`

### VS Code

Files should be linked to `~/Library/Application Support/Code/User`.

### IntelliJ IDEA

The custom keymap needs to linked to the `keymaps` directory of IDEA's config folder.

### Fish shell

Usage of fish shell is deprecated


### Apple keybindings

Workaround taken from [here](https://discussions.apple.com/thread/251108215?sortBy=best)
to fix the behavior of Home and End keys so that they match
the standard Windows behavior. The file is in `DefaultKeyBinding.dict`
and it gets linked to `~/Library/KeyBindings/DefaultKeyBinding.dict`.

## Windows

> Windows setup is not maintained

### Installation on Windows

- Clone the repository
- Open a Command Prompt as Administrator
- From the repository folder, run `install.cmd up`
- To uninstall, run `install.cmd down`

### PowerShell aliases

Add this line to `$Home\Documents\WindowsPowerShell\Profile.ps1`:

```
. "path-to-the-repository\aliases.ps1"
```

### Customized Git Bash prompt

The `git-prompt.sh` file offers a customized Git Bash
prompt for Git Bash on Windows.
The `install.cmd` script will automatically link it
under `$HOME/.config/git`.

## Git aliases

Include this in your own `.gitconfig` by using the `[include]` directive with the path to this file

```
[include]
    path = PATH_TO_REPO/gitconfig_include
```

If you don't have any existing includes, you can add this via the following command

```
git config --global include.path PATH_TO_REPO/gitconfig_include
```

## VIM settings

The `vimrc` file contains VIM settings.
