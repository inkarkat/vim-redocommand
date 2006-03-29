" redocommand.vim : Execute commands from the command history. 
"
"* DESCRIPTION:
"   Reexecutes ex commands previously entered in command mode. A given string is
"   used to locate the most recent matching command. This is similar to the
"   command-line window (q:), or navigating the command history via <Up> and
"   <Down>, but provides an even faster way to reexecuting a command if you
"   remember some characters or an expression that identifies the command line. 
"   The redocommand itself will not be included in the command history. 
"
"* EXAMPLE:
"   :history
"   1 e foo.txt
"   2 %s/foo/\0bar/g
"   3 w bar.txt
"
"   ':Redocommand' will execute the last command ':w bar.txt'
"   ':Redocommand %' will execute ':%s/foo\0/bar/g'
"   ':Redocommand foo' will execute ':%s/foo\0/bar/g'
"
"* CONFIGURATION:
"
"* REMARKS:
"   Modeled after Posix shell 'fc -s' command (which is often aliased to 'r'). 
"
"* TODO:
"   - implement ':Redocommand old=new commandexpr'
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	0.01	23-May-2005	file creation

" Avoid installing twice or when in compatible mode
if exists("loaded_redocommand")
    finish
endif
let loaded_redocommand = 1

command! -nargs=? -complete=command Redocommand call <SID>Redocommand(<f-args>)

function! s:Redocommand( ... )
    if a:0 == 0
	" An empty expression always matches, so this is used for the cornercase
	" of no expression passed in, in which the last history command is
	" executed. 
	let l:commandexpr = ""
    elseif a:0 == 1
	let l:commandexpr = a:1
    else
	assert 0
    endif

    " The history must not be cluttered with :Redocommands. 
    " Remove the ':Redocommand' that is currently executed from the history. 
    call s:RemoveRedocommandFromHistory(l:commandexpr)

    let l:histnr = histnr("cmd") 
    while l:histnr > 0
	let l:historyCommand = histget("cmd", l:histnr)
	if l:historyCommand =~ l:commandexpr
	    echo ":" . l:historyCommand
	    execute l:historyCommand
	    return
	endif
	let l:histnr = l:histnr - 1
    endwhile

    echohl WarningMsg
    echo "No command matching \"" . l:commandexpr . "\" found in history."
    echohl None
endfunction

function! s:RemoveRedocommandFromHistory( commandexpr )
    " Verify whether the last history command actually corresponds to the current
    " :Redocommand. If the command were issued from a script (though I cannot
    " imagine why one would do that), VIM would not include it in the history. 
    "
    " This check isn't that trivial, because the command itself may have been
    " remapped, e.g. to ':R', or only partially entered, e.g. ':Redo', or
    " entered with leading spaces, e.g. ':    :::  Re'. 
    " Even worse, it may be part of a chain of commands (e.g. ':set ai | Redo').
    " In that case, the entire command line will be removed. 

    " First check the simple case that the command has not been remapped and is
    " thus contained in the command history. 
    if stridx( histget("cmd", -1), "Redocommand" ) != -1
	call histdel("cmd", -1)
    " If the command has not been found, search for the commandexpr. 
    " If there wasn't a commandexpr, remove the history element, anyway. 
    elseif a:commandexpr == "" || stridx( histget("cmd", -1), a:commandexpr ) != -1
	call histdel("cmd", -1)
"""""D else
"""""D echomsg "redocommand.vim: Didn't remove command \"" . histget("cmd", -1) . "\" from history"
    endif
endfunction

