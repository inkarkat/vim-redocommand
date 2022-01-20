REDOCOMMAND
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Re-executes the last / Nth Ex command previously entered in command mode. An
optional pattern is used to locate the most recent matching command. This is
similar to the command-line window (q:), or navigating the command history via
&lt;Up&gt; and &lt;Down&gt;, but provides an even faster way to re-execute a command if
you remember some characters or a pattern that identifies the command line.
The redocommand itself will not be included in the command history. Global
literal replacement can be done via 'old=new' arguments.

This is modeled after the 'fc -s' command from the Posix shell (which is often
aliased to 'r').

USAGE
------------------------------------------------------------------------------

    :[N]Redocommand (or abbreviated :R)
                            Execute the last / Nth Ex command.

    :[N]Redocommand {pattern}
                            Execute the last / Nth Ex command that matches
                            {pattern}.
                            Settings such as 'magic' and 'ignorecase' apply.

                            With N=0, only the very last command from the history
                            is executed if it matches {pattern}; the entire
                            history isn't searched.

                            Note: If the {pattern} starts with : (and there is no
                            history command matching the literal ":cmd"), the
                            history is searched for "cmd", anchored at the
                            beginning. This is convenient because ":R :echo" is
                            more intuitive to type than ":R ^echo".

    :[N]Redocommand {old}={new} [{old2}={new2} ...] [{pattern}]
                            Execute the last / Nth Ex command (that matches
                            {pattern}), replacing all literal occurrences of {old}
                            with {new}.

    :[N]RedoRepeat [{old}={new} ...]       (or abbreviated :RR)
                            Execute the last / Nth Ex command that was repeated
                            via :Redocommand. Any replacements done the last time
                            are still in effect; new replacements of {old} to
                            {new} can be added.

    The following variants are useful when you repeatedly use command A in one
    buffer and command B in another. Instead of passing different [N] values to
    :RedoRepeat, just recall from the local redo history.

    :[N]RedoBufferRepeat [{old}={new} ...] (or abbreviated :RB)
                            Like :RedoRepeat, but repeat the last / Nth Ex
                            command repeated in the current buffer.

    :[N]RedoWindowRepeat [{old}={new} ...] (or abbreviated :RW)
                            Like :RedoRepeat, but repeat the last / Nth Ex
                            command repeated in the current window.

EXAMPLE
------------------------------------------------------------------------------

Given the following history:

    :history

    1 e foo.txt
    2 %s/foo/\0bar/g
    3 w bar.txt
:Redocommand            will execute :w bar.txt
:Redocommand %          will execute :%s/foo\\0/bar/g
:Redocommand foo        will execute :%s/foo\\0/bar/g
:2Redocommand foo       will execute :e foo.txt
:Redocommand b=B .txt=  will execute ':w bar.txt' as :w Bar

:echo "another command"
:RedoRepeat             will again execute :w Bar
:2RedoRepeat            will execute :%s/foo\\0/bar/g
:RedoRepeat B=F         will execute :w Far
:Redocommand            will execute :echo "another command"
:RedoRepeat             will execute :w Far

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-redocommand
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vba.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim redocommand.vba.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.008 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

If you do not want the shorthand :R, :RR, :R... commands, define (e.g. in your
vimrc):

    let g:redocommand_no_short_command = 1

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-redocommand/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.41    RELEASEME
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

##### 1.40    20-Jul-2012
- ENH: Add :RedoBufferRepeat / :RB and :RedoWindowRepeat / :RW commands. These
are useful when you repeatedly use command A in one buffer and command B in
another. Instead of passing different [N] values to :RedoRepeat, just recall
from the local redo history.

##### 1.30    23-Nov-2011
- ENH: Add :RedoRepeat command to repeat the last / Nth :Redocommand when other
Ex commands (e.g. :wnext) were issued in between.

##### 1.21    15-Oct-2009 (unreleased)
- ENH: If the {pattern} starts with : (and there is no history command matching
the literal ":cmd"), the history is searched for "cmd", anchored at the
beginning. This is convenient because ":R :echo" is more intuitive to type
than ":R ^echo".

##### 1.20    03-Apr-2009
- Added optional [count] to repeat the Nth, not the last found match.
- Split off documentation into separate help file. Now packaging as VimBall.
- Using separate autoload script to help speed up Vim startup.

##### 1.10    04-Aug-2008
- Implemented ':Redocommand old=new {pattern}'. Now requiring Vim 7.

##### 1.00    04-Aug-2008
- First published version.

##### 0.01    23-May-2005
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2005-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
