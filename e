#!/bin/sh
#
# NAME
#
#   e - wrapper script to connect to the gVim server
#
# SYNOPSIS
#
#   e [<args>...]
#
# DEPENDENCIES
#
#   gVim compiled with +clientserver
#
# SEE ALSO
#
#   vimer <https://github.com/susam/vimer>
#

# Path to the gVim executable.
gvim="/usr/bin/gvim"

# Use the most recent gVim server.
gvim_server=$("$gvim" --serverlist | tail -n -1)

if [ "$*" ]
then
    if [ "$gvim_server" ]
    then
        nohup "$gvim" --servername "$gvim_server" \
                      --remote "$@" >/dev/null </dev/null 2>&1
    else
        nohup "$gvim" "$@" >/dev/null </dev/null 2>&1
    fi

else
    if [ "$gvim_server" ]
    then
        # If there are no files to edit, we need to raise the
        # gVim window manually by calling foreground().
        nohup "$gvim" --servername "$gvim_server" \
                      --remote-expr "foreground()" >/dev/null </dev/null 2>&1
    else
        nohup "$gvim" >/dev/null </dev/null 2>&1
    fi
fi
