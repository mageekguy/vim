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
"	set guifont=Monaco:h11
	nmap <silent> <C-S-Right> :maca _cycleWindowsBackwards:<CR> 
	nmap <silent> <C-S-Left> :maca _cycleWindows:<CR>
	set macligatures
	set guifont=Fira\ Code:h11
endif

augroup fch
	execute 'au BufWritePost .gvimrc source %'
augroup end
