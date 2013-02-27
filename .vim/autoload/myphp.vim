""=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Licence:					GPL version 2.0 license
"=============================================================================
function myphp#foldText()
	let line = getline(v:foldstart)

	if line =~ '^\s*/\*'
		if line =~ '^\s*/\*\+\s*$'
			if v:foldstart + 1 < v:foldend
				let line = substitute(line, '^\(\s*\)/\*.*$', '\1', '') . '/* ' . substitute(getline(v:foldstart + 1), '^\(\s\|\*\)\+', '', '') . ' */'
			endif
		else
			let line = substitute(line, '^\(\s*\)/\*.*$', '\1', '') . '/* ' . substitute(line, '^\s*/\*\+\s*', '', '') . ' */'
		endif
	endif

	let line = substitute(line, '\s*{$', '', '')

	return substitute(line, '	', repeat(' ', &tabstop), 'g') . ' [' . ((v:foldend - v:foldstart) + 1) . ']'
endfunction

function myphp#cleanFile()
	execute 'normal m`'
	%s/\s\+$//ge
	%s/^\s\+$//ge
	if (!&expandtab && search('^ \+', 'cnw'))
		:retab
	endif
	if (&fileformat != 'unix')
		setlocal fileformat=unix
	endif
	if (&filencoding != 'utf8')
		setlocal fileencoding=utf8
	endif
	if (&encoding != 'utf8')
		setlocal encoding=utf8
	endif
	execute 'normal ``'
endfunction

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
