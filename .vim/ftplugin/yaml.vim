""=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						mercredi 12 janvier 2011, 17:55:00 (UTC+0100)
"=============================================================================
if (!exists('yaml#disable') || yaml#disable <= 0) && !exists('b:yaml_loaded')
	let b:yaml_loaded = 1

	augroup yaml
		au! * <buffer>
		au BufCreate,BufRead,BufWrite <buffer> silent! %s///ge
		au BufCreate,BufRead,BufWrite <buffer> silent! %s/\s\+$//ge
		au BufCreate,BufRead,BufWrite <buffer> silent! %s/^\s\+$//ge
	augroup end
endif

finish

" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
