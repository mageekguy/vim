""=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Fri Apr 10 15:16:01 CEST 2009
"=============================================================================
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

function! MyPhpFoldText()
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

setlocal noexpandtab
setlocal tabstop=3
setlocal shiftwidth=3
setlocal rtp+=~/.vim/doc/php
setlocal formatoptions=tcqlro
setlocal keywordprg=:help
setlocal makeprg=/usr/bin/php\ -l\ %
setlocal errorformat=%m\ in\ %f\ on\ line\ %l
setlocal dictionary+=~/.vim/dict/php.txt
setlocal complete+=k/.vim/dict/php.txt
setlocal wildignore=.tags,tags,*.svn,.git,GPATH,GRTAGS,GSYMS,GTAGS
setlocal cindent
setlocal cinoptions=(s,U1,(s,m1
setlocal matchpairs-=<:>
setlocal foldtext=MyPhpFoldText()
setlocal noeol

nnoremap <silent> <LocalLeader>s :sp %:s?tests/units/??<CR>

nnoremap <buffer> <silent> <C-F> :call <SID>selectFunctionInVisualMode()<CR>
nnoremap <buffer> <silent> <CR> :Atoum<CR>
nnoremap <buffer> <silent> <C-CR> :AtoumDebugSwitch<CR>
nnoremap <buffer> <silent> <S-CR> :execute ':Atoum -m *::' . substitute(getline(search('.*function\s\+test[^(]\+(', 'cnb')), '.*function\s\+\(test[^(]\+\)(.*$', '\1', '')<CR>

command! -buffer -range=% -nargs=? SpaceToTab execute '<line1>,<line2>s#^\( \{'.(<q-args> ? <q-args> : &ts).'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')#e'

function! s:cleanFile()
	execute 'normal m`'
	%s/\s\+$//ge
	%s/^\s\+$//ge
	if (&fileformat != 'unix')
		setlocal fileformat=unix
	endif
	if (&fileencoding != 'utf-8')
		setlocal fileencoding=utf-8
	endif
	execute 'normal ``'
endfunction

function! s:selectFunctionInVisualMode()
	execute 'keepjumps ?function'
	execute 'keepjumps /{'
	execute 'keepjumps normal vi{'
endfunction

let s:oldKeyword = ''

function! s:highlightVariable()
	if (! (getline('.')[col('.')-1] =~# '\k'))
		let s:oldKeyword = ''
		match none
	else
		let currentWord = expand('<cword>')

		if (s:oldKeyword != currentWord)
			let s:oldKeyword = currentWord
			execute printf('match IncSearch /\$\<%s\>/', escape(currentWord, '/\'))
		endif
	endif
endfunction

function! s:risingsun(path)
	if (getcwd() == $HOME . '/Risingsun')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace estvoyage\risingsun\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use estvoyage\risingsun\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace estvoyage\risingsun' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

function! s:roman(path)
	if (getcwd() == $HOME . '/roman')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace estvoyage\roman\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use estvoyage\roman\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace estvoyage\roman' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

function! s:tictactoe(path)
	if (getcwd() == $HOME . '/ticTacToe')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace estvoyage\ticTacToe\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use estvoyage\ticTacToe\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace estvoyage\ticTacToe' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

function! s:tdd(path)
	if (getcwd() == $HOME . '/Norsys/tdd')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace norsys\tdd\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use norsys\tdd\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace norsys\tdd' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

function! s:composerScore(path)
	if (getcwd() == $HOME . '/Norsys/Composer/Score')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace norsys\score\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use norsys\score\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace norsys\score' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

function! s:demoTdd(path)
	if (getcwd() == $HOME . '/Norsys/Formations/demo/tdd')
		if (match(a:path, 'tests/units/src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
			let splitedTld = split(tld, '\')

			call append(0, '<?php namespace devarena\tests\units' . tld . ';')
			call append(1, '')
			call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
			call append(3, '')
			call append(4, 'use devarena\tests\units;')
			call append(5, '')
			call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
			call append(7, '{')
			call append(8, '}')
			:$d
			:$
			normal zo
			normal O
		elseif (match(a:path, 'src/.*') >= 0 && line('$') == 1 && getline(1) == '')
			let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
			call append(0, '<?php namespace devarena' . tld . ';')
			call append(1, '')
			call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
			call append(3, '{')
			call append(4, '}')
			:$d
			:$
			normal zo
			normal O
		endif
	endif
endfunction

augroup myphp
	au! InsertEnter <buffer> if !exists('w:lastFoldMethod') | let w:lastFoldMethod=&foldmethod | setlocal foldmethod=manual | endif
	au! InsertLeave,WinLeave <buffer> if exists('w:lastFoldMethod') | let &l:foldmethod=w:lastFoldMethod | unlet w:lastFoldMethod | endif
	au! BufRead,BufWrite <buffer> call <SID>cleanFile()
	au! BufEnter <buffer> setlocal foldtext=MyPhpFoldText()
	au BufEnter <buffer> call <SID>risingsun(expand('<afile>'))
	au BufEnter <buffer> call <SID>roman(expand('<afile>'))
	au BufEnter <buffer> call <SID>tictactoe(expand('<afile>'))
	au BufEnter <buffer> call <SID>tdd(expand('<afile>'))
	au BufEnter <buffer> call <SID>composerScore(expand('<afile>'))
	au BufEnter <buffer> call <SID>demoTdd(expand('<afile>'))
	au! CursorMoved <buffer> call <SID>highlightVariable()
augroup end

ia func function

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
