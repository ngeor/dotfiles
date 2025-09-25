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
        delete_one_file(v)


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


def delete_one_file(files):
    for i in range(0, len(files)):
        for j in range(i + 1, len(files)):
            if filecmp.cmp(files[i], files[j], shallow=False):
                left_score = score(files[i])
                right_score = score(files[j])
                if left_score > right_score:
                    print(f"Removing {files[j]} in favor of {files[i]}")
                    os.remove(files[j])
                    return
                elif left_score < right_score:
                    print(f"Removing {files[i]} in favor of {files[j]}")
                    os.remove(files[i])
                    return
                else:
                    print(f"Equivalent score! Should not happen.")


if __name__ == "__main__":
    main()
