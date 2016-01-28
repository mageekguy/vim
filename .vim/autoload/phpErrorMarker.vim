"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Mar 18 déc 2012 16:04:19 CET
" Licence:					GPL version 2.0 license
"=============================================================================
let s:id = 666

if !exists('g:phpErrorMarker#autowrite')
	let g:phpErrorMarker#autowrite = 0
endif

if !exists('g:phpErrorMarker#openQuickfix')
	let g:phpErrorMarker#openQuickfix = 1
endif

if !exists('g:phpErrorMarker#automake')
	let g:phpErrorMarker#automake = 0
endif

if !exists('g:phpErrorMarker#php')
	let g:phpErrorMarker#php = 'php'
endif

if !exists('g:phpErrorMarker#errorformat')
	let g:phpErrorMarker#errorformat = '%A,%C%s:\ %m\ in\ %f\ on\ line\ %l,%Z%s'
endif

if !exists('g:phpErrorMarker#textError')
	let g:phpErrorMarker#textError = '⚠︎'
endif

if !exists('g:phpErrorMarker#textWarning')
	let phpErrorMarker#textWarning = '⚡︎'
endif

if has('signs')
	execute 'sign define phpErrorMarkerError text=' . g:phpErrorMarker#textError . ' linehl=ErrorMsg'
	execute 'sign define phpErrorMarkerWarning text=' . g:phpErrorMarker#textWarning . ' linehl=WarningMsg'
endif

"automake {{{1
function phpErrorMarker#automake()
	if g:phpErrorMarker#automake
		execute 'normal m`'

		silent! make

		if b:phpErrorMarker_counter <= 0
			execute 'normal ``'
		endif
	endif
endfunction
"autowrite {{{1
function phpErrorMarker#autowrite()
	if g:phpErrorMarker#autowrite && &modified
		w
	endif
endfunction
"markErrors {{{1
function phpErrorMarker#markErrors()
	ccl

	if !exists('b:phpErrorMarker_counter')
		let b:phpErrorMarker_counter = 0
	endif

	call phpErrorMarker#unmarkErrors()

	let errors = getqflist()

	if len(errors)
		for error in errors
			if error['valid'] > 0
				let b:phpErrorMarker_counter += 1

				silent! execute 'sign place ' . (s:id + b:phpErrorMarker_counter) . ' line=' . error['lnum'] . ' name=phpErrorMarker' . (error['text']  =~ '\cwarning' ? 'Warning' : 'Error')  . ' buffer=' . error['bufnr']
			endif
		endfor

		if b:phpErrorMarker_counter > 0
			redraw!

			call cursor(errors[0]['lnum'], errors[0]['col'])

			normal! zv

			if g:phpErrorMarker#openQuickfix
				cw
			endif
		endif
	endif
endfunction
"unmarkErrors {{{1
function phpErrorMarker#unmarkErrors()
	if exists('b:phpErrorMarker_counter') && b:phpErrorMarker_counter > 0
		while b:phpErrorMarker_counter > 0
			silent! execute 'sign unplace ' . (s:id + b:phpErrorMarker_counter)
			let b:phpErrorMarker_counter -= 1
		endwhile
	endif
endfunction
" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
"makeVimball {{{1
function phpErrorMarker#makeVimball()
	split phpErrorMarkerVimball

	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal noswapfile

	let files = 0

	for file in split(globpath(&runtimepath, '**/phpErrorMarker*'), "\n")
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
		execute '%MkVimball! phpErrorMarker'

		setlocal nomodified
		bwipeout

		echomsg 'Vimball is in ''' . getcwd() . ''''
	catch /.*/
		echohl ErrorMsg
		echomsg v:exception
		echohl None
	endtry
endfunction
" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
