#!/usr/bin/env python

import os
import unicodedata


def main():
    root = os.path.normpath(os.path.abspath("F:"))
    process(root)


def process(root):
    for name in os.listdir(root):
        if name == "System Volume Information":
            continue
        full_path = os.path.join(root, name)
        if os.path.isfile(full_path):
            rename_if_needed(root, name)
        elif os.path.isdir(full_path):
            process(full_path)
            rename_if_needed(root, name)
        else:
            raise ValueError(f"not a file not a directory: {full_path}")


def rename_if_needed(root, name):
    if has_greek_characters_or_nonspacing_mark(name):
        new_name = to_greeklish(name)
        old_full_path = os.path.join(root, name)
        new_full_path = os.path.join(root, new_name)

        if os.path.exists(new_full_path):
            print(f"!!!CLASH!!! {new_full_path}")
        else:
            print(f"Would have renamed {old_full_path} {new_full_path}")
            # os.rename(old_full_path, new_full_path)


map = {
    "α": "a",
    "β": "v",
    "γ": "g",
    "δ": "d",
    "ε": "e",
    "ζ": "z",
    "η": "i",
    "θ": "th",
    "ι": "i",
    "κ": "k",
    "λ": "l",
    "μ": "m",
    "ν": "n",
    "ξ": "x",
    "ο": "o",
    "π": "p",
    "ρ": "r",
    "σ": "s",
    "ς": "s",
    "τ": "t",
    "υ": "u",
    "φ": "f",
    "χ": "ch",
    "ψ": "ps",
    "ω": "o",
    # uppercase
    "Α": "A",
    "Β": "V",
    "Γ": "G",
    "Δ": "D",
    "Ε": "E",
    "Ζ": "Z",
    "Η": "I",
    "Θ": "Th",
    "Ι": "I",
    "Κ": "K",
    "Λ": "L",
    "Μ": "M",
    "Ν": "N",
    "Ξ": "X",
    "Ο": "O",
    "Π": "P",
    "Ρ": "R",
    "Σ": "S",
    "Τ": "T",
    "Υ": "U",
    "Φ": "F",
    "Χ": "Ch",
    "Ψ": "Ps",
    "Ω": "O",
    # strange dash
    "–": "-",
}


def has_greek_characters_or_nonspacing_mark(name):
    for ch in name:
        if ch in map or is_nonspacing_mark(ch):
            return True
    return False


def to_greeklish(name):
    result = ""
    for ch in unicodedata.normalize("NFD", name):
        if does_not_need_escape(ch):
            new_ch = ch
        elif is_nonspacing_mark(ch):
            new_ch = ""
        else:
            new_ch = map[ch]
            assert does_not_need_escape(new_ch), f"{ch} -> {new_ch}"
        result += new_ch
    return result

def is_nonspacing_mark(ch):
    return unicodedata.category(ch) == "Mn"

def does_not_need_escape(ch):
    return (
        (ch >= "a" and ch <= "z")
        or (ch >= "A" and ch <= "Z")
        or (ch >= "0" and ch <= "9")
        or (ch in " .@&-_()[]!',;#°")
    )


if __name__ == "__main__":
    main()
