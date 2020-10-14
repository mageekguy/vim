"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Licence:					GPL version 2.0 license
"=============================================================================
function! StatuslineGit(path)
  let b:GitBranch = system("git -C " . a:path . " rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  let b:GitBranch = strlen(b:GitBranch) > 0 ? '|' . b:GitBranch : ''
endfunction

augroup GitBranch
  autocmd!
  autocmd CursorHold,BufEnter,BufNewFile,BufReadPost * call g:StatuslineGit(expand('%:h'))
augroup END

set regexpengine=1
set relativenumber
set exrc
set secure
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set backup
set backupdir=~/.vimbackup
set cindent
set cmdheight=1
set completeopt=menuone
set copyindent
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,mac,dos
set fillchars=fold:\ 
set fillchars=vert:\ 
set foldclose=
set foldmethod=syntax
set gdefault
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:\│\ ,trail:-,precedes:<,extends:>,nbsp:↓
set linebreak
set modeline
set nocompatible
set nocursorcolumn
set noequalalways
set noerrorbells
set noexpandtab
set nojoinspaces
set noswapfile
set nowrap
set nrformats=octal,hex,alpha
set number
set ruler
set scrolljump=-100
set scrolloff=5
set selection=inclusive
set shiftround
set shiftwidth=3
set showcmd
set showmatch
set showmode
set showtabline=1
set sidescroll=1
set sidescrolloff=5
set smartcase
set smarttab
set splitbelow
set splitright
set statusline=%3n
set statusline+=\│%-4{&ff}
set statusline+=\│%-7{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}
set statusline+=\│%-7{&filetype}
set statusline+=\│%{(!&modifiable?'○':(&modified>0?'●':'\ '))}
set statusline+=%{printf('%s',exists(\"b:GitBranch\")?b:GitBranch:\'\')}
set statusline+=\|%{coc#status()} 
set statusline+=%w%f
set statusline+=%=
set statusline+=\│%6c
set statusline+=\│%6{printf('%s',line('.'))}/%-6L
set statusline+=\│%3p%% 
set switchbuf=split
set synmaxcol=1000
set tabstop=3
set title
set ttyfast
set vb t_vb=
set viminfo='20,\"50,:20,%,n~/.viminfo
set whichwrap=<,>,h,l,[,]
set wildchar=<Tab>
set wildcharm=<C-Z>
set wildignorecase
set wildmenu
set wildmode=longest:full
set winminheight=0
set winminwidth=0
set t_Co=256
set grepprg=grep\ -rin\ $*
set clipboard+=unnamed
set nojoinspaces
set guicursor=i-ci:hor25-Cursor-blinkwait300-blinkon200-blinkoff150
set regexpengine=2
set termguicolors
set updatetime=200
set signcolumn=number
set shortmess+=c

if v:version >= 703
	set undofile
	set undodir=~/.vimundo
	set norelativenumber

	nnoremap <silent> <F2> :execute 'set ' . (&relativenumber ? 'norelativenumber' : 'relativenumber')<CR>
endif

let g:solarized_underline=0
let g:solarized_visibility="normal"

colorscheme solarized

syntax on

let mapleader = "\<Space>"
let maplocalleader = ','

filetype plugin on
filetype indent off

nnoremap <silent> <C-S-Up> <C-W>k<C-W>_
nnoremap <silent> <C-S-Down> <C-W>j<C-W>_
nnoremap <silent> <Tab> <C-W>x<C-W>_
nnoremap <silent> <C-S-Enter> <C-W>_
nnoremap <silent> <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> . .`[
nnoremap <silent> gf :sp <cfile><CR>
nnoremap * *N
nnoremap # #N

function! s:Only(file)
	exec ':only'
	exec ':e ' . a:file
endfunction

command! -complete=file -nargs=1 Only call s:Only(<q-args>)

function! s:RenameTo(newName)
    let currentName = expand('%')
    if a:newName != '' && a:newName != currentName
        exec ':saveas ' . a:newName
        exec ':silent !rm ' . currentName
        redraw!
    endif
endfunction

command! -complete=file -nargs=1 RenameTo call s:RenameTo(<q-args>)
cabbrev <expr> RenameTo 'RenameTo ' . expand('%')

function! s:SkipWhiteLine(direction)
	execute 'normal ' . a:direction

	while getline('.') == ''
		execute 'normal ' . a:direction
	endwhile
endfunction

nnoremap <silent> <PageUp> :call <SID>SkipWhiteLine('k')<CR>
nnoremap <silent> <PageDown> :call <SID>SkipWhiteLine('j')<CR>
nnoremap \ m`:keepjumps normal ggVG<CR><Esc>``/\%V\%V<Left><Left><Left>

vnoremap < <gv
vnoremap > >gv
vnoremap / <Esc>/\%V\%V<Left><Left><Left>
vnoremap ? <Esc>?\%V\%V<Left><Left><Left>

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

function! s:checkBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>checkBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent> <expr> <C-Tab> coc#refresh()

nmap <leader>rn <Plug>(coc-rename)

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
	let directory = fnamemodify(resolve(expand('%')), ':h')
	let file = fnamemodify(resolve(expand('%')), ':t')
	let filetype = &filetype

	execute ':silent! vsp ' . tempname()
	execute ':silent! set modifiable'
	execute ':0r !git -C ' . directory . ' show HEAD~1:./' . file
	execute ':silent! $d'
	execute ':silent! set readonly'
	execute ':silent! set ft=' . filetype
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile
endfunction

command! -nargs=0 GitPrevious call s:GitPrevious()

function! s:GitDiff()
	let directory = fnamemodify(resolve(expand('%')), ':h')
	let file = fnamemodify(resolve(expand('%')), ':t')
	let filetype = &filetype

	execute ':silent! vertical diffs ' . tempname()
	execute ':silent! set modifiable'
	execute ':0r !git -C ' . directory . ' diff HEAD~1 ./' . file
	execute ':silent! $d'
	execute ':silent! set readonly'
	execute ':silent! set ft=' . filetype
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile
endfunction

command! -nargs=0 GitDiff call s:GitDiff()

augroup vimrc
	au!

	" Color in active status line
	au BufWinEnter,WinEnter * hi statusline guibg=#268bd2 guifg=#eee8d5 gui=NONE

	au WinEnter * hi wildmenu guibg=DarkGreen gui=NONE
	au WinEnter * set cursorline nocursorcolumn

	" Fullscreen when open
	au BufWinEnter * :execute "normal \<C-W>_"

	" Create directory if not exists
	au BufWritePre * :silent !mkdir -p %:h

	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
	au WinLeave * set nocursorline nocursorcolumn

	au BufEnter * sign define dummy
	au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

	execute 'au BufWritePost .vimrc source %'
augroup end

vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader><Leader> V

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>s :wq<CR>
nnoremap <Leader>v V
nnoremap <S-n> ~

runtime! plugin/**/*.vim

let g:netrw_liststyle=3
let g:netrw_preview   = 1
let g:netrw_winsize   = 30

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

let g:echodoc#enable_at_startup=1

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Initialize plugin system
call plug#end()
