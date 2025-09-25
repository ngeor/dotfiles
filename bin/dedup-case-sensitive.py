#!/usr/bin/env python
import argparse
import filecmp
import os
import os.path
import shutil


def main():
    parser = argparse.ArgumentParser(
        prog="dedup-case-sensitive.py",
        description="Deduplicate files/folders due to case sensitive issues",
    )
    parser.add_argument(
        "--copy", required=False, help="Copy this file if it is missing"
    )
    parser.add_argument(
        "--copy-dir",
        required=False,
        help="Copy missing files of this directory",
    )
    parser.add_argument(
        "--delete-duplicate", required=False, help="Delete duplicate file"
    )
    args = parser.parse_args()
    left_dir = "/Users/ngeor/Music/Music/Media.localized/Music"
    right_dir = "/Users/ngeor/Music/Music/Media.localized/Musicold"
    if args.copy:
        copy_missing(left_dir, right_dir, args.copy)
    elif args.copy_dir:
        copy_missing_files(left_dir, right_dir, args.copy_dir)
    elif args.delete_duplicate:
        delete_duplicate_file(args.delete_duplicate)
    else:
        walk_dir(left_dir, right_dir)


def walk_dir(left_dir, right_dir):
    # a dictionary from the uppercase of the filename to the actual filename
    left = {x.upper(): x for x in listdir_filtered(left_dir)}
    right = {x.upper(): x for x in listdir_filtered(right_dir)}

    for x in left:
        if x in right:
            if left[x] == right[x]:
                handle_match(left_dir, right_dir, left[x])
            else:
                print(f"Case mismatch {left[x]} vs {right[x]}")
        else:
            print(f"Only in left {left_dir}/{left[x]}")

    for x in right:
        if not x in left:
            print(f"Only in right {right_dir}/{right[x]}")


def handle_match(left_dir, right_dir, name):
    left_full_name = os.path.join(left_dir, name)
    right_full_name = os.path.join(right_dir, name)
    if os.path.isfile(left_full_name):
        if os.path.isfile(right_full_name):
            # if file, compare contents
            compare_file(left_full_name, right_full_name)
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


def compare_file(left, right):
    if os.path.getsize(left) != os.path.getsize(right):
        print(f"Size mismatch {left} vs {right}")
    else:
        # actually compare contents
        pass


def copy_missing(left_dir, right_dir, full_name):
    if not os.path.isfile(full_name):
        raise ValueError(f"{full_name} is not a file")
    new_full_name = get_counterpart(left_dir, right_dir, full_name)
    if os.path.isfile(new_full_name):
        raise ValueError(f"File {new_full_name} already exists")
    shutil.copy(full_name, new_full_name)


def copy_missing_files(left_dir, right_dir, full_name):
    if not os.path.isdir(full_name):
        raise ValueError(f"{full_name} is not a directory or does not exist")
    new_full_name = get_counterpart(left_dir, right_dir, full_name)
    if not os.path.isdir(new_full_name):
        raise ValueError(f"{new_full_name} is not a directory or does not exist")
    do_copy_missing_files_left_to_right(full_name, new_full_name)


def do_copy_missing_files_left_to_right(left_dir, right_dir):
    left = {x.upper(): x for x in listdir_filtered(left_dir)}
    right = {x.upper(): x for x in listdir_filtered(right_dir)}
    for x in left:
        if not x in right and os.path.isfile(os.path.join(left_dir, left[x])):
            shutil.copy(
                os.path.join(left_dir, left[x]), os.path.join(right_dir, left[x])
            )


def get_counterpart(left_dir, right_dir, full_name):
    """
    Gets the matching filename of `full_name` in the other directory structure.
    """
    if full_name.startswith(left_dir + "/"):
        return full_name.replace(left_dir, right_dir)
    elif full_name.startswith(right_dir + "/"):
        return full_name.replace(right_dir, left_dir)
    else:
        raise ValueError(f"File {full_name} must belong to one of the two directories")


def delete_duplicate_file(full_name):
    # go up two levels
    root_dir = os.path.dirname(os.path.dirname(full_name))
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            candidate = os.path.join(root, file)
            if os.path.realpath(full_name) == os.path.realpath(candidate):
                continue
            if filecmp.cmp(full_name, os.path.join(root, file), shallow=False):
                print(f"Found duplicate {candidate}")
                os.remove(full_name)
                return
    print("No duplicate found!")


if __name__ == "__main__":
    main()
