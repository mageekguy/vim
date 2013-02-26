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
set lcs=tab:˒\ ,trail:-,precedes:<,extends:>
set noerrorbells
set novisualbell
set vb t_vb=
set linespace=2
set antialias

if has("gui_macvim")
	set fu
	set fuopt+=maxhorz
	set fuopt+=maxvert
	let macvim_skip_cmd_opt_movement = 1
endif

augroup fch
	execute 'au! BufWritePost ' . resolve($MYGVIMRC) . ' source %'
augroup end
