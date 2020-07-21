if !exists('g:test#python#toxwithstestr#file_pattern')
  let g:test#python#toxwithstestr#file_pattern = '^test_.*\.py$'
endif

function! test#python#toxwithstestr#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#toxwithstestr#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner == 'toxwithstestr'
    else
      return executable('tox')
    endif
  endif
endfunction

function! test#python#toxwithstestr#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['-e py3 -- '.substitute(substitute(a:position['file'], "/", "\\.", "g"), "\\.py", "\\.", "g").''.name]
    else
      return [a:position['file']]
    endif
  elseif a:type == 'file'
    return ['-e py3 -- --no-discover '.a:position['file']]
  else
    return ['']
  endif
endfunction

function! test#python#toxwithstestr#build_args(args) abort
  let args = a:args

  " if test#base#no_colors()
  "   let args = ['--color=no'] + args
  " endif

  return args
endfunction

function! test#python#toxwithstestr#executable() abort
  return 'tox'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
