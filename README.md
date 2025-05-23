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

-   [2ascii](2ascii) and [2utf8](2utf8) converts text files to ASCII and
    UTF-8, respectively.

-   [2mp3](2mp3) transcodes audio files to MP3 using FFMpeg.

-   [adb-refresh](adb-refresh) uses ADB to refresh media storage on an
    Android device.

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

-   [brep](brep) and [ffind](ffind) are "intelligent" wrappers around
    GNU's version of grep and find that takes care of 90% of their use
    cases for me.

-   [huecat](huecat) is an NIH [lolcat][lolcat] implementation in
    Python that will concatenate files (just like cat) and garishly
    print the contents on the stdout (assumed to be attached to
    a 256-color terminal).  Huecat is so [rainbow rhythms!][huecat]
    Example usage:

        fortune | cowsay | huecat
        man vi | huecat -f | less

-   [fullfeed](fullfeed) converts partial RSS feeds (i.e., feeds that
    force you to click and link to read the full post) into full feeds.

-   PDF manipulation scripts based on [PDFtk][pdftk] and Ghostscript:
    [pdfbew](pdfbw) converts PDFs to grayscale;
    [pdfcompress](pdfcompress) compresses PDF files using Ghostscript;
    [pdfmetaedit](pdfmetaedit) is a script that will let you edit the
    metadata (e.g., "author" and "title" fields) of a PDF file using
    `$EDITOR`; [pdfmetastrip](pdfmetastrip) strips (most) metadata from
    a PDF file; [pdfsed](pdfsed) is a script that lets you edit PDF
    files using sed.

-   [photorename](photorename) is a script to canonicalize and rename
    media files based on their creation date.

-   [plmgr](plmgr) is a media player agnostic M3U playlist manager.  Its
    only purpose is to add/delete the currently playing track to/from
    a playlist file.

-   SubRip (SRT) subtitle manipulation scripts: [srtextract](srtextract)
    can be used to extract subtitles from a video file.
    [srtpol](srtpol) is a sed script to "polish" (i.e., smarten quotes,
    fix dashes, etc.) subtitles.  [srtran](srtran) can be used to
    linearly transform subtitle timestamps (to fix framerate issues, for
    instance).

-   [e](e) and [editinvim](editinvim) are helper scripts for gVim. e can
    be used to connect to an active gVim server or start a new one.
    editinvim can be used to edit textboxes in (most) GUI applications
    using gVim.

-   [tala](tala) is a wrapper script around cryptsetup and friends to
    make it easier to create and manage LUKS containers (aka devices).
    tala was written as an alternative to TrueCrypt.

-   [pass][pass] helper scripts: [passprint](passprint) converts
    a password store into a PDF so that you can [print your
    passwords][password].  [passmenu](passmenu) helps you pick passwords
    using rofi or dmenu.

-   [inkconv](inkconv) is a handy script that uses Inkscape to
    interconvert EMF, EPS, PDF, PNG, PS, SVG, WMF, and XAML files.

-   [mutt-open](mutt-open) is a file opener that integrates xdg-open
    with mutt.

-   [x230t-rotate](x230t-rotate) is a display rotation script to be used
    with a ThinkPad X230t tablet (and other Wacom tablets).

-   Calibre-based ebook utilities: [ebook-formats](ebook-formats)
    interconverts a directory of EPUB and MOBI ebooks in parallel.
    [ebook-organize](ebook-organize) reorganizes a directory of ebooks
    into the form _.../author/title/title.ext_.

-   LaTeX-related utilities: [texclean](texclean) remove temporary files
    left around when compiling LaTeX documents, [texprune](texprune)
    makes a clean copy of a LaTeX source tree keeping only the essential
    files, and [texstrip](texstrip) removes all comments from a LaTeX
    file.

License
-------

Public domain.  See the file UNLICENSE for more details.

[bash]: https://www.gnu.org/software/bash
[com]: http://www.iq0.com/duffgram/com.html
[coreutils]: https://www.gnu.org/software/coreutils/coreutils.html
[goop]: https://www.forbes.com/sites/brucelee/2018/01/06/gwyneth-paltrows-goop-promotes-a-135-coffee-enema-kit
[huecat]: https://raw.githubusercontent.com/manu-mannattil/assets/master/scripts/huecat.png
[lolcat]: https://github.com/busyloop/lolcat
[pass]: https://www.passwordstore.org
[password]: https://www.schneier.com/blog/archives/2005/06/write_down_your.html
[pdftk]: http://www.pdftk.com
[posix]: http://pubs.opengroup.org/onlinepubs/9699919799
