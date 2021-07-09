if exists("b:did_indent")
    finish
endif

let b:did_indent = 1

setlocal smartindent
setlocal autoindent
setlocal cindent
setlocal nolisp
setlocal comments=s1:/*,mb:*,ex:*/,://,:#
setlocal formatoptions-=t
setlocal formatoptions+=q
setlocal formatoptions+=r
setlocal formatoptions+=o
setlocal formatoptions+=c
setlocal formatoptions+=b
