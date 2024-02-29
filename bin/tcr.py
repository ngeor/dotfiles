#!/usr/bin/env python
# TCR: test && commit || revert, as seen in Kent Beck's article https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864

import os
import os.path
import platform
import subprocess
import sys


def main():
    # TODO don't do this on the master branch
    # TODO don't do this if there are no pending changes
    (test() and commit()) or revert()


def test():
    if os.path.isfile("pom.xml"):
        return test_with_maven()
    else:
        print("No test framework detected")
        return False


def test_with_maven():
    cmd = "mvn.cmd" if platform.system() == "Windows" else "mvn"
    return run([cmd, "-B", "test"])


def commit():
    message = sys.argv[1] if len(sys.argv) > 1 else "WIP"
    return run(["git", "add", "-A"]) and run(["git", "commit", "-m", message])


def revert():
    subprocess.run(["git", "reset", "--hard", "HEAD"], check=True)
    sys.exit(42)


def run(cmd):
    return subprocess.run(cmd).returncode == 0


if __name__ == "__main__":
    main()
