"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Licence:					GPL version 2.0 license
"=============================================================================
set nocompatible
set autoindent
set cindent
set backspace=indent,eol,start
set cmdheight=1
set completeopt=longest,menuone
set cursorline
set nocursorcolumn
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,mac,dos
set fillchars=vert:\ 
set fillchars=fold:\ 
set foldclose=
set foldmethod=syntax
set hlsearch
set laststatus=2
set lcs=tab:\|\ ,trail:-,precedes:<,extends:>
set list
set backup
set backupdir=~/.vimbackup
set noexpandtab
set modeline
set noswapfile
set nowrap
set nrformats=octal,hex,alpha
set number
set ruler
set scrolljump=1
set scrolloff=5
set shiftwidth=3
set showcmd
set showmatch
set showmode
set showtabline=1
set sidescroll=1
set sidescrolloff=5
set gdefault
set incsearch
set ignorecase
set smartcase
set smarttab
set statusline=%<%w%f\ %=%y[%{&ff}][%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}][%6c][%{printf('%'.strlen(line('$')).'s',line('.'))}/%L][%3p%%]%{'['.(&readonly?'RO':'\ \ ').']'}%{'['.(&modified?'+':'-').']'}
set switchbuf=useopen
set synmaxcol=1000
set tabstop=3
set title
set ttyfast
set lazyredraw
set viminfo='20,\"50,:20,%,n~/.viminfo
set wildmenu
set wildmode=longest:full
set wildchar=<Tab>
set wildcharm=<C-Z>
set winminheight=0
set winminwidth=0
set whichwrap=<,>,h,l,[,]
set noerrorbells
set vb t_vb=
set selection=inclusive
set splitbelow
set splitright
set noequalalways
set nojoinspaces
set background=dark

if v:version >= 703
	set undofile
	set undodir=~/.vimundo
	set norelativenumber

	nnoremap <silent> <F2> :execute 'set ' . (&relativenumber ? 'norelativenumber' : 'relativenumber')<CR>
endif

let &t_Co=256
let g:solarized_termcolors=256
let g:solarized_underline=0
let g:solarized_visibility="low"

colorscheme solarized

syntax on

let mapleader = ','
let maplocalleader = ','

filetype plugin on

nnoremap <silent> <C-Up> <C-W>W
nnoremap <silent> <C-Left> <C-W>h
nnoremap <silent> <C-Down> <C-W>w
nnoremap <silent> <C-Right> <C-W>l
nnoremap <silent> <C-S-Up> <C-W>k\|:execute 'resize ' . line('$')<CR>
nnoremap <silent> <C-S-Down> <C-W>j\|:execute 'resize ' . line('$')<CR>
nnoremap <silent> <Tab> <C-W>x\|:execute 'resize ' . line('$')<CR>
nnoremap <silent> <C-S-Enter> <C-W>_
nnoremap <silent> <C-PageDown> zj
nnoremap <silent> <C-PageUp> zk
nnoremap <silent> <Space>  za
nnoremap <silent> <expr> <leader>p '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> . .`[
nnoremap <silent> <F11> :Shell!<CR>

function! s:SkipWhiteLine(direction)
	execute 'normal ' . a:direction

	while getline('.') == ''
		execute 'normal ' . a:direction
	endwhile
endfunction

nnoremap <PageUp> :call <SID>SkipWhiteLine('k')<CR>
nnoremap <PageDown> :call <SID>SkipWhiteLine('j')<CR>
nnoremap \ m`:keepjumps normal ggVG<CR><Esc>``/\%V\%V<Left><Left><Left>

vnoremap < <gv
vnoremap > >gv
vnoremap / <Esc>/\%V\%V<Left><Left><Left>
vnoremap ? <Esc>?\%V\%V<Left><Left><Left>

inoremap <expr> <Space> pumvisible() ? "\<C-y><Space>" :"\<C-g>u\<Space>"
inoremap <expr> <Right> pumvisible() ? "\<C-y>" :"\<C-g>u\<Right>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <C-Tab> pumvisible() ? "<Down>" : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <C-S-Tab> <C-X><C-O>

au! BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
au! WinLeave * set nocursorline nocursorcolumn
au! WinEnter * set cursorline nocursorcolumn

augroup fch
	execute 'au! BufWritePost .vimrc source %'
augroup end

let g:phpErrorMarker#autowrite = 1
let g:phpErrorMarker#automake = 1

let s:_ = ''

function! s:ExecuteInShell(command, bang)
	let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

	if (_ != '')
		let s:_ = _
		let bufnr = bufnr('%')
		let winnr = bufwinnr('^' . _ . '$')
		silent! execute  winnr < 0 ? 'belowright new ' . fnameescape(_) : winnr . 'wincmd w'
		setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile wrap number
		silent! :%d
		let message = 'Execute ' . _ . '...'
		call append(0, message)
		echo message
		silent! 2d | resize 1 | redraw
		silent! execute 'silent! %!'. _
		silent! execute 'resize ' . line('$')
		silent! execute 'syntax on'
		silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
		silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
		silent! execute 'nnoremap <silent> <buffer> <CR> :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
		nnoremap <silent> <buffer> <C-W>_ :execute 'resize ' . line('$')<CR>
		silent! syntax on
	endif
endfunction

command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell

function! s:GitPrevious()
	let _ = './' . expand('%')
	let filetype = &filetype

	execute ':silent! vsp ' . tempname()
	execute ':silent! 0r !git show HEAD~1:' . _
	execute ':silent! $d'
	execute ':silent! set nomodifiable'
	execute ':silent! set readonly'
	execute ':silent! set ft=' . filetype
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile
endfunction

command! -nargs=0 GitPrevious call s:GitPrevious()

call atoum#defineConfiguration('/Users/fch/Atoum/repository', '/Users/fch/Atoum/repository/vim.php', '.php')

" Color in active status line
autocmd BufEnter * hi statusline guibg=#859900 guifg=Black gui=NONE
autocmd BufEnter * hi wildmenu guibg=DarkGreen gui=NONE

" Create directory if not exists
au! BufWritePre * :silent !mkdir -p %:h

runtime! plugin/**/*.vim
