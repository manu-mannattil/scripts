scripts
=======

> "I am rarely happier than when spending an entire day programming my
> computer to perform automatically a task that it would otherwise take
> me a good ten seconds to do by hand." -- Douglas Adams, *Last Chance
> to See*

An assorted collection of little scripts that I use from time to time.
I've tried to make the shell scripts as [POSIX][posix] compatible as
possible, but some require [Bash][bash] and/or [GNU
Coreutils][coreutils].  Also, most scripts are standalone scripts that
require only a few external dependencies (with almost all of them
available in the Debian repositories).

Highlights
----------

-   [goop](goop) is a filename "detoxing" script named after the
    [company][goop] of the same name.  The basic usage is `goop <file>...`.
    The purpose of goop is to safely remove spaces and other special
    characters from the filenames of the supplied files and restrict
    each filename to the character set `[a-zA-Z0-9._-]`.

-   [com](com) is an NIH Python implementation of Tom Duff's
    [program][com] of the same name, with some changes in function.
    com scans the supplied files line by line and looks for comment
    lines beginning with the keyword "com:" and executes the rest of the
    line as a shell command, e.g., consider `hello.c`:

        /* com: \{ cc {} -o {.} ; \} && {.}
         */

        /* contents of hello.c */

    On running `com hello.c`, com will replace `{}` and `{.}` with
    "hello.c" and "hello".  This way, `hello.c` can be compiled (and
    executed) without writing a makefile.

-   [lyrics](lyrics) is a lyrics fetcher script that fetches song
    lyrics (from AZLyrics at the moment) according to the supplied
    keywords.  Typos in the keywords are usually handled without
    a problem.  Example usage:

        lyrics rebecca black friday
        lyrics rebeca blcak thursday

        # Fetch lyrics of current song in the player, e.g., DeaDBeeF.
        lyrics $(deadbeef --nowplaying '%a %t' 2>/dev/null)

-   [huecat](huecat) is an NIH [lolcat][lolcat] implementation in
    Python that will concatenate files (just like cat) and garishly
    print the contents on the stdout (assumed to be attached to
    a 256-color terminal).  Huecat is so [rainbow rhythms!][huecat]
    Example usage:

        fortune | cowsay | huecat
        man vi | huecat -f | less

-   PDF manipulation scripts based on [PDFtk][pdftk] and Ghostscript:
    [pdfcompress](pdfcompress) compresses PDF files using Ghostscript;
    [pdfmetaedit](pdfmetaedit) is a script that will let you edit the
    metadata (e.g., "author" and "title" fields) of a PDF file using
    `$EDITOR`; [pdfmetastrip](pdfmetastrip) strips (most) metadata from
    a PDF file; [pdfsed](pdfsed) is a script that lets you edit PDF
    files using sed.

-   [plmgr](plmgr) is a media player agnostic M3U playlist manager.  Its
    only purpose is to add/delete the currently playing track from
    a playlist file.

-   SubRip (SRT) subtitle manipulation scripts: [srtextract](srtextract)
    can be used to extract subtitles from a video file.
    [srtpol](srtpol) is a sed script to "polish" (i.e., smarten quotes,
    fix dashes, etc.) subtitles.  [srtran](srtran) can be used to
    linearly transform subtitle timestamps (to fix framerate issues, for
    instance).

-   [e](e) and [editinvim](editinvim) are helper scripts for gVim. e can
    be used to connect to an active gVim server or start a new one.
    editinvim can be used to edit textboxes in any GUI application using
    gVim.

-   [tala](tala) is a wrapper script around cryptsetup and friends to
    make it easier to create and manage LUKS containers (aka devices).
    tala was written as an alternative to TrueCrypt.

License
-------

Public domain.  See the file UNLICENSE for more details.

[bash]: https://www.gnu.org/software/bash/
[com]: http://www.iq0.com/duffgram/com.html
[coreutils]: https://www.gnu.org/software/coreutils/coreutils.html
[goop]: https://www.forbes.com/sites/brucelee/2018/01/06/gwyneth-paltrows-goop-promotes-a-135-coffee-enema-kit
[huecat]: https://i.imgur.com/g5YxOKw.png
[lolcat]: https://github.com/busyloop/lolcat
[pdftk]: http://www.pdftk.com
[posix]: http://pubs.opengroup.org/onlinepubs/9699919799/
