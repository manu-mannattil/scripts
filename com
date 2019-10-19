#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# com is a "Not Invented Here" Python port of [1] with some minor
# changes in function.  The basic usage is
#
#   com [<options>] file [<args>]
#
# For more details about com's options, run
#
#   com --help
#
# com scans the supplied files line by line and looks for comment lines
# beginning with the keyword "com: " and executes the rest of the line
# as a shell command.  When doing so, it substitutes the following
# variables [2]
#
#   variable    substitution
#   --------    ------------
#
#   {}          full path to the file
#   {.}         full path without extension
#   {..}        extension of the file
#   {/}         basename of the full path
#   {//}        dirname of the full path
#   {/.}        basename of the full path without extension
#   {@}         additional arguments supplied
#
# The main purpose of com is to make it easier to compile simple
# programs without writing a makefile.  For instance, a rudimentary
# one-file C program (say hello.c) can be compiled using com by adding
# the following line in the comments:
#
#   /* com: \{ cc {} -o {.} ; \} && {.}
#    */
#
#   ... contents of hello.c ...
#
# This way, the program can be compiled (and executed) by running
#
#   com hello.c
#
# In the above example, we have escaped curly braces using \{ and \} to get
# literal { and }.
#
# com can also be used to compile LaTeX files by adding the following
# directive in the comments:
#
#   % com: pdflatex {}
#   % com: bibtex {.}.aux
#   % com: pdflatex {}
#   % com: pdflatex {}
#
# [1]: http://www.iq0.com/duffgram/com.html
# [2]: The variable names have been inspired by GNU Parallel conventions.
#

import argparse
import re
import subprocess
import sys
from os import path
from shlex import quote

# Regex to match "com lines" according to file extension.
DEFAULT_RE = r"^\s*#+\s*com\s*:\s*"
EXTENSION_RE = {
    ".c": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".cc": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".cpp": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".go": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".hs": r"^\s*({?-+|--+)\s*com\s*:\s*",
    ".js": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".lhs": r"^\s*({?-+|--+)\s*com\s*:\s*",
    ".rs": r"^\s*(\/?\*+|\/\/)\s*com\s*:\s*",
    ".scm": r"^\s*;+\s*com\s*:\s*",
    ".tex": r"^\s*%+\s*com\s*:\s*"
}


def process(line, attributes):
    """Process the given line."""
    line = re.sub(attributes["regex"], "", line)

    # Hack to support escaping of \{ and \}.
    line = line.replace("\\{", "\0ob\0")
    line = line.replace("\\}", "\0cb\0")

    line = line.replace("{}", attributes.get("name", ""))
    line = line.replace("{.}", attributes.get("stem", ""))
    line = line.replace("{..}", attributes.get("extension", ""))
    line = line.replace("{/}", attributes.get("basename", ""))
    line = line.replace("{//}", attributes.get("dirname", ""))
    line = line.replace("{/.}", attributes.get("stembase", ""))
    line = line.replace("{@}", attributes.get("args", ""))

    # Replace escaped {}'s if any and cleanup.
    line = line.replace("\0ob\0", "{")
    line = line.replace("\0cb\0", "}")

    return line.strip()


def com(fd, args=None, dry_run=False, shell=None, debug=False):
    """Compile a file."""
    # Convert to absolute path and make an attributes dictionary.
    name = path.abspath(fd.name)
    attributes = {
        "name": quote(name),                                         # {}
        "stem": quote(path.splitext(name)[0]),                       # {.}
        "extension": quote(path.splitext(name)[1]),                  # {..}
        "basename": quote(path.basename(name)),                      # {/}
        "dirname": quote(path.dirname(name)),                        # {//}
        "stembase": quote(path.basename(path.splitext(name)[0]))     # {/.}
    }

    # If there are additional arguments, quote them safely
    # and make a string.
    if args:
        attributes.update({"args": " ".join(map(quote, args))})

    regex = EXTENSION_RE.get(attributes["extension"], DEFAULT_RE)
    attributes.update({"regex": regex})

    commands = list()
    for line in fd:
        if re.match(regex, line):
            commands.append(process(line, attributes))

    if dry_run:
        print("\n".join(commands), file=sys.stderr)
        return
    elif debug:
        # All POSIX compliant shells support passing the -x option that
        # will print each command before execution.
        args = ["-x", "\n".join(commands)]
    else:
        args = ["\n".join(commands)]

    return subprocess.Popen(args, shell=True, executable=shell).wait()


def main():
    """Argument parsing."""
    arg_parser = argparse.ArgumentParser(
        prog="com",
        description="compile anything"
    )
    arg_parser.add_argument(
        "-n", "--dry-run", action="store_true",
        help="print the commands that will be executed"
    )
    arg_parser.add_argument(
        "-s", "--shell", default=None,
        help="set the shell to use"
    )
    arg_parser.add_argument(
        "-x", "--x-trace", action="store_true",
        help="trace each step by passing '-x' to the shell"
    )
    arg_parser.add_argument(
        "file", help="files", type=argparse.FileType("r")
    )
    arg_parser.add_argument(
        "args", help="additional arguments", nargs="*"
    )

    args = arg_parser.parse_args()
    com(args.file, args.args, args.dry_run, args.shell, args.x_trace)


if __name__ == "__main__":
    sys.exit(main())
