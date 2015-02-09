"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Mar 18 déc 2012 16:03:55 CET
" Licence:					GPL version 2.0 license
" GetLatestVimScripts:	2794 11432 :AutoInstall: phpErrorMarker.vim
"=============================================================================
if (!exists('phpErrorMarker#disable') || phpErrorMarker#disable <= 0) && !exists('b:phpErrorMarker_loaded')
	let b:phpErrorMarker_loaded = 1

	if &cp
		echomsg 'No compatible mode is required by phpErrorMarker'
	elseif !has('signs')
		echomsg 'Signs feature is required by phpErrorMarker'
	else
		let s:cpo = &cpo
		setlocal cpo&vim

		let &makeprg = g:phpErrorMarker#php . ' -nl %'
		let &errorformat = g:phpErrorMarker#errorformat

		augroup phpErrorMarker
			au!
			au BufWritePost <buffer> call phpErrorMarker#automake()
			au InsertLeave <buffer> call phpErrorMarker#unmarkErrors()
		augroup end

		au! QuickFixCmdPre make call phpErrorMarker#autowrite()
		au! QuickFixCmdPost make call phpErrorMarker#markErrors()

		command -buffer -nargs=0 MarkPhpErrors call phpErrorMarker#markErrors()
		command -buffer -nargs=0 UnmarkPhpErrors call phpErrorMarker#unmarkErrors()
		command -buffer -nargs=0 PhpErrorMarkerVimball call phpErrorMarker#makeVimball()

		let &cpo = s:cpo
		unlet s:cpo
	endif
endif

finish

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
