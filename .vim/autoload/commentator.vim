"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Fri Sep 25 14:29:10 CEST 2009
" Licence:					GPL version 2.0 license
"=============================================================================
"error {{{1
function commentator#error(message)
	echohl ErrorMsg
	echomsg 'commentator: ' . a:message
	echohl None
endfunction
"setToken
function commentator#setToken()
	let b:commentator_token = []

	if &filetype == 'php' || &filetype == 'c' || &filetype == 'cpp' || &filetype == 'java'
		let b:commentator_token = [ '//', '' ]
	elseif &filetype == 'vim'
		let b:commentator_token = [ '"', '' ]
	elseif &filetype == 'html' || &filetype == 'xml'
		let b:commentator_token = [ '<!--', '-->' ]
	elseif &filetype == 'python' || &filetype == 'perl' || &filetype == 'make' || &filetype =~ '[^w]sh$' || &filetype == 'tcl' || &filetype == 'apache'
		let b:commentator_token = [ '#', '' ]
	endif
endfunction
"tokenIsSet {{{1
function commentator#tokenIsSet()
	return exists('b:commentator_token') && len(b:commentator_token)
endfunction
"comment {{{1
function commentator#comment() range
	try
		if commentator#tokenIsSet()
			let lineNumber = a:firstline

			while lineNumber <= a:lastline
				let line = getline(lineNumber)

				if line !~ '^\s*' . b:commentator_token[0] . '.*' . b:commentator_token[1] . '$'
					silent! call setline(lineNumber, substitute(line, '^\(.*$\)', b:commentator_token[0] . '\1' . b:commentator_token[1], ''))
				endif

				let lineNumber += 1
			endwhile

			call cursor(a:lastline + 1, col('.'))
		endif
	catch
		call commentator#error(v:exception)
	endtry
endfunction
"uncomment {{{1
function commentator#uncomment() range
	try
		if commentator#tokenIsSet()
			let lineNumber = a:firstline

			while lineNumber <= a:lastline
				let line = getline(lineNumber)

				if line =~ '^\s*' . b:commentator_token[0] . '.*' . b:commentator_token[1] . '$'
					silent! call setline(lineNumber, substitute(line, '^\(\s*\)' . b:commentator_token[0] . '\(.*\)' . b:commentator_token[1] . '$', '\1\2', ''))
				endif

				let lineNumber += 1
			endwhile

			call cursor(a:lastline + 1, col('.'))
		endif
	catch
		call commentator#error(v:exception)
	endtry
endfunction
"toggleComment {{{1
function commentator#toggleComment(direction) range
	try
		if commentator#tokenIsSet()
			let lineNumber = a:firstline

			while lineNumber <= a:lastline
				let line = getline(lineNumber)

				silent! call setline(lineNumber, line !~ '^\s*' . b:commentator_token[0] . '.*' . b:commentator_token[1] . '$' ? substitute(line, '^\(.*$\)', b:commentator_token[0] . '\1' . b:commentator_token[1], '') : substitute(line, '^\(\s*\)' . b:commentator_token[0] . '\(.*\)' . b:commentator_token[1] . '$', '\1\2', ''))

				let lineNumber += 1
			endwhile

			call cursor(a:lastline + a:direction, col('.'))
		endif
	catch
		call commentator#error(v:exception)
	endtry
endfunction
"makeVimball {{{1
function commentator#makeVimball()
	split commentatorVimball

	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal noswapfile

	let files = 0

	for file in split(globpath(&runtimepath, '**/commentator*'), "\n")
		for runtimepath in split(&runtimepath, ',')
			if file =~ '^' . runtimepath
				if getftype(file) != 'dir'
					let files += 1
					call setline(files, substitute(file, '^' . runtimepath . '/', '', ''))
				else
					for subFile in split(glob(file . '/**'), "\n")
						if getftype(subFile) != 'dir'
							let files += 1
							call setline(files, substitute(subFile, '^' . runtimepath . '/', '', ''))
						endif
					endfor
				endif
			endif
		endfor
	endfor

	try
		execute '%MkVimball! commentator'

		setlocal nomodified
		bwipeout

		echomsg 'Vimball is in ''' . getcwd() . ''''
	catch
		call commentator#error(v:exception)
	endtry
endfunction
" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
