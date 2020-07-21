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
	let cword = expand('<cword>')
	let l:syntaxgroup = synIDattr(synIDtrans(synID(line('.'), stridx(getline('.'), l:cword) + 1, 1)), 'name')
	let highlight = l:syntaxgroup != 'Identifier' ? '\V\<\>' :  printf('\$\<%s\>', escape(l:cword, '/\'))
	exe 'match IncSearch /' . l:highlight . '/'
endfunction

augroup myphp
	au! InsertEnter <buffer> if !exists('w:lastFoldMethod') | let w:lastFoldMethod=&foldmethod | setlocal foldmethod=manual | endif
	au! InsertLeave,WinLeave <buffer> if exists('w:lastFoldMethod') | let &l:foldmethod=w:lastFoldMethod | unlet w:lastFoldMethod | endif
	au! BufRead,BufWrite <buffer> call <SID>cleanFile()
	au! BufEnter <buffer> setlocal foldtext=MyPhpFoldText()
	au! CursorHold <buffer> call <SID>highlightVariable()
augroup end

ia func function

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
