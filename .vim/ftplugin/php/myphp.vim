""=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Fri Apr 10 15:16:01 CEST 2009
"=============================================================================
if (!exists('myphp#disable') || myphp#disable <= 0) && !exists('b:myphp_loaded')
	let b:myphp_loaded = 1

	setlocal rtp+=~/.vim/doc/php
	setlocal formatoptions=tcqlro
	setlocal keywordprg=:help
	setlocal makeprg=/usr/bin/php\ -l\ %
	setlocal errorformat=%m\ in\ %f\ on\ line\ %l
	setlocal dictionary+=~/.vim/dict/php.txt
	setlocal complete+=k/.vim/dict/php.txt
	setlocal wildignore=.tags,tags,*.svn,.git,GPATH,GRTAGS,GSYMS,GTAGS
	setlocal cindent
	setlocal matchpairs-=<:>
	setlocal foldtext=myphp#foldText()

	nnoremap <buffer> <silent> <C-F> :call <SID>selectFunctionInVisualMode()<CR>

	nnoremap <buffer> <silent> <CR> :Atoum<CR>
	nnoremap <buffer> <silent> <C-CR> :AtoumDebugSwitch<CR>
	nnoremap <buffer> <silent> <S-CR> :execute ':Atoum -m *::' . substitute(getline(search('.*function\s\+test[^(]\+(', 'cnb')), '.*function\s\+\(test[^(]\+\)(.*$', '\1', '')<CR>

	command! -buffer -range=% -nargs=? SpaceToTab execute '<line1>,<line2>s#^\( \{'.(<q-args> ? <q-args> : &ts).'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')#e'

	function! s:selectFunctionInVisualMode()
		let currentWord =  '\\$' . expand('<cword>')
		execute 'keepjumps ?function'
		execute 'keepjumps /{'
		execute 'keepjumps normal vi{'
		echomsg 'normal! /\\%V' . currentWord . '\\%V'
		execute 'normal! /\\%V' . currentWord . '\\%V'
	endfunction

	augroup myphp
		au!
		au InsertEnter <buffer> if !exists('w:lastFoldMethod') | let w:lastFoldMethod=&foldmethod | setlocal foldmethod=manual | endif
		au InsertLeave,WinLeave <buffer> if exists('w:lastFoldMethod') | let &l:foldmethod=w:lastFoldMethod | unlet w:lastFoldMethod | endif
		au BufRead,BufWrite <buffer> call myphp#cleanFile()
		au BufEnter <buffer> setlocal foldtext=myphp#foldText()
	augroup end
endif

finish

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
