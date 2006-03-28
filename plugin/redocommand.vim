" redocommand.vim : Execute commands from the command history. 
"
"* REMARKS:
"   Modeled after Posix shell 'fc -s' command. 
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
    " :Redocommand by searching for the commandexpr argument. 
    " (this check isn't that trivial, because the command itself may have been
    " remapped, e.g. to ':R', or only partially entered, e.g. ':Redo'). 

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

