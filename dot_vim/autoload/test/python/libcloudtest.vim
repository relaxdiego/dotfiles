if !exists('g:test#python#libcloudtest#file_pattern')
  let g:test#python#libcloudtest#file_pattern = '^test_.*\.py$'
endif

function! test#python#libcloudtest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#libcloudtest#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner == 'libcloudtest'
    else
      return executable('PYTHONPATH=. python')
    endif
  endif
endfunction

function! test#python#libcloudtest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].' '.name]
    else
      return [a:position['file']]
    endif
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return ['setup.py', 'test']
  endif
endfunction

function! test#python#libcloudtest#build_args(args) abort
  let args = a:args

  " if test#base#no_colors()
  "   let args = ['--color=no'] + args
  " endif

  return args
endfunction

function! test#python#libcloudtest#executable() abort
  return 'PYTHONPATH=. python'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
