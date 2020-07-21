" Name:    localvimrc.vim
" Version: 3.0.1
" Author:  Markus Braun <markus.braun@krawel.de>
" Summary: Vim plugin to search local vimrc files and load them.
" Licence: This program is free software: you can redistribute it and/or modify
"          it under the terms of the GNU General Public License as published by
"          the Free Software Foundation, either version 3 of the License, or
"          (at your option) any later version.
"
"          This program is distributed in the hope that it will be useful,
"          but WITHOUT ANY WARRANTY; without even the implied warranty of
"          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"          GNU General Public License for more details.
"
"          You should have received a copy of the GNU General Public License
"          along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" Section: Plugin header {{{1

" guard against multiple loads {{{2
if (exists("g:loaded_localvimrc") || &cp)
	finish
endif

let g:loaded_localvimrc = 1

" check for correct vim version {{{2
if version < 702
	finish
endif

" Section: Default settings {{{1

" define default "localvimrc_enable" {{{2
let s:localvimrc_enable = 1
if (exists("g:localvimrc_enable") && type(g:localvimrc_enable) == type(0))
	let s:localvimrc_enable = g:localvimrc_enable
endif

" define default "localvimrc_name" {{{2
" copy to script local variable to prevent .lvimrc modifying the name option.
let s:localvimrc_name = [ ".lvimrc" ]
if (exists("g:localvimrc_name"))
	if type(g:localvimrc_name) == type("")
		let s:localvimrc_name = [ g:localvimrc_name ]
	elseif type(g:localvimrc_name) == type([])
		let s:localvimrc_name = g:localvimrc_name
	endif
endif

" define default "localvimrc_event" {{{2
" copy to script local variable to prevent .lvimrc modifying the event option.
let s:localvimrc_event = [ "BufWinEnter" ]
if (exists("g:localvimrc_event") && type(g:localvimrc_event) == type([]))
	let s:localvimrc_event = g:localvimrc_event
endif

" define default "localvimrc_event_pattern" {{{2
" copy to script local variable to prevent .lvimrc modifying the event pattern
" option.
let s:localvimrc_event_pattern = "*"
if (exists("g:localvimrc_event_pattern") && type(g:localvimrc_event_pattern) == type(""))
	let s:localvimrc_event_pattern = g:localvimrc_event_pattern
endif

" define default "localvimrc_reverse" {{{2
" copy to script local variable to prevent .lvimrc modifying the reverse option.
let s:localvimrc_reverse = 0
if (exists("g:localvimrc_reverse") && type(g:localvimrc_reverse) == type(0))
	let s:localvimrc_reverse = g:localvimrc_reverse
endif

" define default "localvimrc_count" {{{2
" copy to script local variable to prevent .lvimrc modifying the count option.
let s:localvimrc_count = -1
if (exists("g:localvimrc_count") && type(g:localvimrc_count) == type(0))
	let s:localvimrc_count = g:localvimrc_count
endif

" define default "localvimrc_autocmd" {{{2
" copy to script local variable to prevent .lvimrc modifying the autocommand
" option.
let s:localvimrc_autocmd = 1
if (exists("g:localvimrc_autocmd") && type(g:localvimrc_autocmd) == type(0))
	let s:localvimrc_autocmd = g:localvimrc_autocmd
endif

" define default "localvimrc_debug" {{{2
if (!exists("g:localvimrc_debug"))
	let g:localvimrc_debug = 1
endif

" define default "localvimrc_debug_lines" {{{2
" this defines the number of debug messages kept in a buffer
let s:localvimrc_debug_lines = 100
if (exists("g:localvimrc_debug_lines"))
	let s:localvimrc_debug_lines = g:localvimrc_debug_lines
endif

" Section: Autocmd setup {{{1

if has("autocmd")
	augroup localvimrc
		autocmd!

	for event in s:localvimrc_event
		" call s:LocalVimRC() when creating or reading any file
		exec "autocmd ".event." ".s:localvimrc_event_pattern." call s:LocalVimRC()"
	endfor
	augroup END
endif

" Section: Functions {{{1

" Function: s:LocalVimRC() {{{2
"
" search all local vimrc files from current directory up to root directory and
" source them in reverse order.
"
function! s:LocalVimRC()
	if s:localvimrc_enable == 0
		return
	endif

	call s:LocalVimRCDebug(1, "== START LocalVimRC() ============================")
	call s:LocalVimRCDebug(1, "localvimrc.vim " . g:loaded_localvimrc)

	" only consider normal buffers (skip especially CommandT's GoToFile buffer)
	" NOTE: in general the buftype is not set for new buffers (BufWinEnter),
	"       e.g. for help files via plugins (pydoc)
	if !empty(&buftype)
		call s:LocalVimRCDebug(1, "not a normal buffer, exiting")
		return
	endif

	" directory of current file (correctly escaped)
	let l:directory = fnameescape(expand("%:p:h"))

	if empty(l:directory)
		let l:directory = fnameescape(getcwd())
	endif

	call s:LocalVimRCDebug(1, "searching directory \"" . l:directory . "\"")

	" generate a list of all local vimrc files with absolute file names along path to root
	let l:rcfiles = []

	for l:rcname in s:localvimrc_name
		call s:LocalVimRCDebug(1, "searching directory \"" . l:directory . "\"")

		for l:rcfile in s:findFile(l:rcname, l:directory)
			let l:rcfile_unresolved = fnamemodify(l:rcfile, ":p")
			let l:rcfile_resolved = resolve(l:rcfile_unresolved)
			call insert(l:rcfiles, { "resolved": l:rcfile_resolved, "unresolved": l:rcfile_unresolved } )
		endfor
	endfor

	call s:LocalVimRCDebug(1, "found files: " . string(l:rcfiles))

	" shrink list of found files
	if (s:localvimrc_count >= 0 && s:localvimrc_count < len(l:rcfiles))
		call remove(l:rcfiles, 0, len(l:rcfiles) - s:localvimrc_count - 1)
	endif

	" reverse order of found files if reverse loading is requested
	if (s:localvimrc_reverse != 0)
		call reverse(l:rcfiles)
	endif

	call s:LocalVimRCDebug(1, "candidate files: " . string(l:rcfiles))

	" source all found local vimrc files in l:rcfiles variable
	let s:localvimrc_finish = 0
	let l:answer = ""
	let l:sandbox_answer = ""
	let l:sourced_files = []
	for l:rcfile_dict in l:rcfiles
		" get values from dictionary
		let l:rcfile = l:rcfile_dict["resolved"]
		let l:rcfile_unresolved = l:rcfile_dict["unresolved"]
		call s:LocalVimRCDebug(2, "processing \"" . l:rcfile . "\"")

		" generate command
		let l:command = "source " . fnameescape(l:rcfile)

		" emit an autocommand before sourcing
		if (s:localvimrc_autocmd == 1)
			call s:LocalVimRCUserAutocommand('LocalVimRCPre')
		endif

		exec l:command

		" emit an autocommands after sourcing
		if (s:localvimrc_autocmd == 1)
			call s:LocalVimRCUserAutocommand('LocalVimRCPost')
		endif

		call add(l:sourced_files, l:rcfile)

		" check if sourcing of files should be ended by variable set by
		" local vimrc file
		if (s:localvimrc_finish != 0)
			break
		endif
	endfor

	" store information about source local vimrc files in buffer local variable
	if exists("b:localvimrc_sourced_files")
		call extend(l:sourced_files, b:localvimrc_sourced_files)
	endif

	if exists("*uniq")
		call uniq(sort(l:sourced_files))
	else
		let l:sourced_files_uniq = {}

		for l:file in l:sourced_files
			let l:sourced_files_uniq[l:file] = 1
		endfor

		let l:sourced_files = sort(keys(l:sourced_files_uniq))
	endif

	let b:localvimrc_sourced_files = l:sourced_files

	" end marker
	call s:LocalVimRCDebug(1, "== END LocalVimRC() ==============================")
endfunction

" Function: s:LocalVimRCUserAutocommand(event) {{{2
"
function! s:LocalVimRCUserAutocommand(event)
	if exists('#User#'.a:event)
		call s:LocalVimRCDebug(1, 'executing User autocommand '.a:event)

		if v:version >= 704 || (v:version == 703 && has('patch442'))
			exec 'doautocmd <nomodeline> User ' . a:event
		else
			exec 'doautocmd User ' . a:event
		endif
	endif
endfunction

" Function: LocalVimRCEnable() {{{2
"
" enable processing of local vimrc files
"
function! s:LocalVimRCEnable()
	" if this call really enables the plugin load the local vimrc files for the
	" current buffer
	if s:localvimrc_enable == 0
		call s:LocalVimRCDebug(1, "enable processing of local vimrc files")
		let s:localvimrc_enable = 1
		call s:LocalVimRC()
	endif
endfunction

" Function: LocalVimRCDisable() {{{2
"
" disable processing of local vimrc files
"
function! s:LocalVimRCDisable()
	call s:LocalVimRCDebug(1, "disable processing of local vimrc files")
	let s:localvimrc_enable = 0
endfunction

" Function: LocalVimRCFinish() {{{2
"
" finish processing of local vimrc files
"
function! LocalVimRCFinish()
	call s:LocalVimRCDebug(1, "will finish sourcing files after this file")
	let s:localvimrc_finish = 1
endfunction

" Function: s:LocalVimRCEdit() {{{2
"
" open the local vimrc file for the current buffer in an split window for
" editing. If more than one local vimrc file has been sourced, the user
" can decide which file to edit.
"
function! s:LocalVimRCEdit()
	if exists("b:localvimrc_sourced_files")
		let l:items = len(b:localvimrc_sourced_files)

		if l:items == 0
			call s:LocalVimRCError("No local vimrc file has been sourced")
		elseif l:items == 1
			" edit the only sourced file
			let l:file = b:localvimrc_sourced_files[0]
		elseif l:items > 1
			" build message for asking the user
			let l:message = [ "Select local vimrc file to edit:" ]
			call extend(l:message, map(copy(b:localvimrc_sourced_files), 'v:key+1 . " " . v:val'))

			" ask the user which one should be edited
			let l:answer = inputlist(l:message)
			if l:answer =~ '^\d\+$' && l:answer > 0 && l:answer <= l:items
			let l:file = b:localvimrc_sourced_files[l:answer-1]
		endif
	endif

	if exists("l:file")
		execute 'silent! split ' . fnameescape(l:file)
	endif
endfunction

" Function: s:LocalVimRCError(text) {{{2
"
" output error message
"
function! s:LocalVimRCError(text)
	echohl ErrorMsg | echom "localvimrc: " . a:text | echohl None
endfunction

" Function: s:LocalVimRCDebug(level, text) {{{2
"
" store debug message, if this message has high enough importance
"
function! s:LocalVimRCDebug(level, text)
	if (g:localvimrc_debug >= a:level)
		call add(s:localvimrc_debug_message, a:text)

		" if the list is too long remove the first element
		if len(s:localvimrc_debug_message) > s:localvimrc_debug_lines
			call remove(s:localvimrc_debug_message, 0)
		endif
	endif
endfunction

function! s:findFile(name, path)
	let rcfiles = []
	let path = fnamemodify(a:path, ':p')

	if path == a:path
		let path = fnameescape(getcwd()) . '/' . a:path
	endif

	while path != '/'
		call s:LocalVimRCDebug(1, 'find ' . path . ' -type f -name ' . a:name . ' -depth 1')

		let rcfile = path . '/' . a:name

		if filereadable(rcfile)
			let rcfiles = insert(rcfiles, rcfile)
		endif

		let path = fnamemodify(path, ':h')
	endwhile

	return l:rcfiles
endfunction

" Function: s:LocalVimRCDebugShow() {{{2
"
" output stored debug message
"
function! s:LocalVimRCDebugShow()
	for l:message in s:localvimrc_debug_message
		echo l:message
	endfor
endfunction

" Section: Initialize internal variables {{{1

" initialize processing finish flag {{{2
let s:localvimrc_finish = 0

" initialize debug message buffer {{{2
let s:localvimrc_debug_message = []

" Section: Report settings {{{1

call s:LocalVimRCDebug(1, "== START settings ================================")
call s:LocalVimRCDebug(1, "localvimrc_enable = \"" . string(s:localvimrc_enable) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_name = \"" . string(s:localvimrc_name) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_event = \"" . string(s:localvimrc_event) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_event_pattern = \"" . string(s:localvimrc_event_pattern) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_reverse = \"" . string(s:localvimrc_reverse) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_count = \"" . string(s:localvimrc_count) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_autocmd = \"" . string(s:localvimrc_autocmd) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_debug = \"" . string(g:localvimrc_debug) . "\"")
call s:LocalVimRCDebug(1, "localvimrc_debug_lines = \"" . string(s:localvimrc_debug_lines) . "\"")
call s:LocalVimRCDebug(1, "== END settings ==================================")

" Section: Commands {{{1

command! LocalVimRC        call s:LocalVimRC()
command! LocalVimRCEdit    call s:LocalVimRCEdit()
command! LocalVimRCEnable  call s:LocalVimRCEnable()
command! LocalVimRCDisable call s:LocalVimRCDisable()
command! LocalVimRCDebugShow call s:LocalVimRCDebugShow()

" vim600: foldmethod=marker foldlevel=0 :
