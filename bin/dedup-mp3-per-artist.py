#!/usr/bin/env python
import filecmp
import os
import os.path


def main():
    root_dir = "/Users/ngeor/Music/Music/Media.localized/Music"
    for entry in os.scandir(root_dir):
        if entry.is_dir():
            find_duplicates(entry.path)


def find_duplicates(path):
    # group all files in this subtree by their file size
    files_by_size = dict()
    for root, dirs, files in os.walk(path):
        for file in files:
            full_name = os.path.join(root, file)
            size = os.path.getsize(full_name)
            files_by_size.setdefault(size, []).append(full_name)
    # remove sizes that have only one file
    sizes = list(files_by_size.keys())
    for size in sizes:
        if len(files_by_size[size]) == 1:
            files_by_size.pop(size)
    if len(files_by_size) == 0:
        return
    # compare contents
    for k, v in files_by_size.items():
        for i in range(0, len(v)):
            for j in range(i + 1, len(v)):
                if filecmp.cmp(v[i], v[j], shallow=False):
                    print(f"\t{v[i]} == {v[j]}")
                    print(f"\t{score(v[i])} == {score(v[j])}")

def score(file_name):
    result = 0
    for ch in file_name:
        if ch in "*?;,":
            # penalty for weird charachter
            result -= 5
        elif ch >= "α" and ch <= "ω":
            # bonus for Greek characters (over greeklish)
            result += 3
        else:
            result += 1
    return result

if __name__ == "__main__":
    main()
