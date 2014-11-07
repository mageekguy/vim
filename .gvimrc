"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Licence:					GPL version 2.0 license
"=============================================================================
set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=r
set guioptions-=L
set guioptions-=b
set guioptions+=h
set lcs=tab:│\ ,trail:-,precedes:<,extends:>
set antialias
set vb t_vb=

if has("gui_macvim")
	set fuopt+=maxhorz
	set fuopt+=maxvert
	set guifont=Monaco:h11
	let macvim_skip_cmd_opt_movement=1
endif

augroup fch
	execute 'au! BufWritePost .gvimrc source %'
augroup end
