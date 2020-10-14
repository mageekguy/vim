function! php#test(path, namespace)
	if (line('$') == 1 && getline(1) == '')
		let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'tests/units/src', '', ''), '/', '\', 'g')
		let splitedTld = split(tld, '\')

		call append(0, '<?php namespace ' . a:namespace . '\tests\units' . tld . ';')
		call append(1, '')
		call append(2, 'require __DIR__ . ''/' . repeat('../', (len(splitedTld)) + 1) . 'runner.php'';')
		call append(3, '')
		call append(4, 'use eastoriented\tests\units;')
		call append(5, '')
		call append(6, 'class ' . fnamemodify(a:path, ':t:r') . ' extends units\test')
		call append(7, '{')
		call append(8, '}')
		:$d
		:$
		normal zo
		normal O
	endif
endfunction

function! php#src(path, namespace)
	if (line('$') == 1 && getline(1) == '')
		let tld = substitute(substitute(fnamemodify(a:path, ':h'), 'src', '', ''), '/', '\', 'g')
		call append(0, '<?php namespace ' . a:namespace . tld . ';')
		call append(1, '')
		call append(2, 'class ' . fnamemodify(a:path, ':t:r'))
		call append(3, '{')
		call append(4, '}')
		:$d
		:$
		normal zo
		normal O
	endif
endfunction

