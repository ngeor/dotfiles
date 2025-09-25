#!/usr/bin/env python
import os
import os.path


def main():
    left_dir = "/Users/ngeor/Music/Music/Media.localized/Music"
    right_dir = "/Users/ngeor/Music/Music/Media.localized/Musicold"
    walk_dir(left_dir, right_dir)


def walk_dir(left_dir, right_dir):
    left = set(listdir_filtered(left_dir))
    right = set(listdir_filtered(right_dir))
    for x in left:
        if x in right:
            handle_match(left_dir, right_dir, x)
        else:
            print(f"Only in {left_dir}: {x}")
    for x in right:
        if not x in left:
            print(f"Only in {right_dir}: {x}")


def handle_match(left_dir, right_dir, name):
    left_full_name = os.path.join(left_dir, name)
    right_full_name = os.path.join(right_dir, name)
    if os.path.isfile(left_full_name):
        if os.path.isfile(right_full_name):
            # if file, compare contents
            pass
        else:
            raise ValueError(f"File vs non-file {left_full_name}")
    elif os.path.isdir(left_full_name):
        if os.path.isdir(right_full_name):
            # if dir, walk
            walk_dir(left_full_name, right_full_name)
        else:
            raise ValueError(f"Dir vs non-dir {left_full_name}")
    else:
        raise ValueError(f"Not a file nor a dir {left_full_name}")


def listdir_filtered(dir):
    return (x for x in os.listdir(dir) if not x == ".DS_Store")


if __name__ == "__main__":
    main()
