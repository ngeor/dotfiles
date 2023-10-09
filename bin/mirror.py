#!/usr/bin/env python

from pathlib import Path
import subprocess
import sys


def main():
    if len(sys.argv) >= 2:
        # M:\ needs to point to \\192.168.2.1\ilisia\ngeor\mirror\envy
        dest_root = Path(sys.argv[1])
    else:
        dest_root = Path("E:\\")
    if not dest_root.is_dir():
        raise ValueError(f"{dest_root} is not a directory or does not exist")
    do_copy(dest_root)


def do_copy(dest_root):
    simple_dirs = [
        #".gnupg",
        ".ssh",
        #"AndroidStudioProjects",
        "Archive",
        "Documents",
        "DOSBOX",
        "Google Drive",
        "Music",
        "Pictures",
        "Projects",
        "vbox",
        "Videos",
    ]
    for s in simple_dirs:
        copy_dir(Path.home() / s, dest_root / s)

    copy_dir("C:\\Windows\\Fonts", dest_root / "Fonts")
    copy_dir("C:\\opt", dest_root / "opt")
    copy_dir(
        Path.home() / "AppData" / "Roaming" / "Code" / "User", dest_root / "VSCode"
    )
    robocopy(
        [Path.home(), dest_root, ".bash_aliases", ".bash_profile", ".bashrc", ".vimrc"]
    )


def copy_dir(source_folder, destination_folder):
    robocopy(
        [
            source_folder,
            destination_folder,
            "/S",
            "/COPY:DT",
            "/DCOPY:T",
            "/R:5",
            "/W:5",
            "/PURGE",
            "/XJ",
            "/XD",
            "node_modules",
            "/XF",
            "Thumbs.db",
            "desktop.ini",
        ]
    )


def robocopy(args):
    result = subprocess.run(["robocopy"] + args)
    # https://ss64.com/nt/robocopy-exit.html
    # 16: Serious error. Robocopy did not copy any files.
    # Either a usage error or an error due to insufficient access privileges
    # on the source or destination directories.
    if result.returncode >= 16:
        raise ValueError(f"Serious error copying {args}")


if __name__ == "__main__":
    main()
