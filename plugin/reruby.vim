if exists('g:loaded_reruby')
  finish
endif
let g:loaded_reruby = 1

function! s:RunRefactor(subcmd, ...)
  let l:current_line = getpos(".")[1]
  let l:file_name = @%
  let l:rest_args = join(a:000)

  let l:command = 'reruby '.a:subcmd.' -l '.l:file_name.':'.l:current_line.' '.l:rest_args

  let l:execution_result = system(l:command)
  if v:shell_error
    echo('Something went wrong: '. l:result)
  endif
  edit
endfunction


command! -nargs=* Reruby :call <SID>RunRefactor(<f-args>)

