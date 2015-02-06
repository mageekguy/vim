"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Fri Sep 25 14:48:22 CEST 2009
" Licence:					GPL version 2.0 license
" GetLatestVimScripts:	
"=============================================================================
if (!exists('g:commentator#disable') || g:commentator#disable <= 0) && !exists('g:commentator#loaded')
	let g:commentator#loaded = 1

	if &cp
		echomsg 'No compatible mode is required by commentator'
	else
		let s:cpo = &cpo
		setlocal cpo&vim

		command -nargs=0 -range Comment <line1>,<line2>call commentator#comment()
		command -nargs=0 -range Uncomment <line1>,<line2>call commentator#uncomment()
		command -nargs=0 -range CommentToggle <line1>,<line2>call commentator#toggleComment(0)
		command -nargs=0 -range CommentToggleUp <line1>,<line2>call commentator#toggleComment(-1)
		command -nargs=0 -range CommentToggleDown <line1>,<line2>call commentator#toggleComment(1)
		command -nargs=0 CommentatorVimball call commentator#makeVimball()

		if !hasmapto('<Plug>commentatorComment')
			nmap <unique> <silent> <C-c> <Plug>commentatorComment
			vmap <unique> <silent> <C-c> <Plug>commentatorComment
		endif

		nnoremap <unique> <script> <Plug>commentatorComment <SID>commentatorComment
		nnoremap <SID>commentatorComment :call commentator#toggleComment(1)<CR>

		vnoremap <unique> <script> <Plug>commentatorComment <SID>commentatorComment
		vnoremap <SID>commentatorComment :call commentator#toggleComment(1)<CR>

		augroup commentator
			au!
			au Filetype * call commentator#setToken()
		augroup end

		let &cpo = s:cpo
		unlet s:cpo
	endif
endif

finish

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
