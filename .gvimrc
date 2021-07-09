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
set guicursor=n:block
set antialias

if has("gui_macvim")
	set fuoptions=maxvert,maxhorz

	nmap <silent> <C-S-Right> :maca _cycleWindowsBackwards:<CR>
	nmap <silent> <C-S-Left> :maca _cycleWindows:<CR>
	set macligatures
	set guifont=FiraCode-Light:h12
	aunmenu TouchBar
	autocmd! FullScreenTouchBar
	an TouchBar.-Sep1- <Nop>
	an icon=NSTouchBarSidebarTemplate TouchBar.Explorer :Lexplore<CR>
	an TouchBar.-Sep2- <Nop>
	an icon=NSTouchBarHistoryTemplate TouchBar.Previous :GitPrevious<CR>
	an icon=NSTouchBarRefreshTemplate TouchBar.Diff :GitDiff<CR>
	an TouchBar.-Sep3- <Nop>
	nmenu icon=NSTouchBarGoDownTemplate TouchBar.Down <C-S-Down>
	nmenu icon=NSTouchBarGoUpTemplate TouchBar.Up <C-S-Up>
	an TouchBar.-Sep4- <Nop>
	nmenu icon=NSTouchBarGoBackTemplate TouchBar.Left <C-S-Left>
	nmenu icon=NSTouchBarGoForwardTemplate TouchBar.Right <C-S-Right>
else
	set guioptions+=m
endif

augroup fch
	execute 'au BufWritePost .gvimrc source %'
augroup end
