#!/usr/bin/env python

# test && commit || revert

import subprocess
import sys


def main():
    (test() and commit()) or revert()


def test():
    return run(["mvn", "-B", "test"])


def commit():
    message = sys.argv[1] if len(sys.argv) >= 1 else "wip"
    return run(["git", "cm", message])


def revert():
    subprocess.run(["git", "reset", "--hard", "HEAD"], check=True)
    sys.exit(42)


def run(args):
    result = subprocess.run(args)
    return result.returncode == 0


if __name__ == "__main__":
    main()
