if exists('g:loaded_reruby')
  finish
endif
let g:loaded_reruby = 1

function! s:RunRefactor(subcmd, ...)
  let l:current_line = getpos(".")[1]
  let l:file_name = @%
  let l:rest_args = join(a:000)

  let l:command = 'reruby '.a:subcmd.' --report json -l '.l:file_name.':'.l:current_line.' '.l:rest_args.' 2> /dev/null'


  let l:executionResult = system(l:command)

  if v:shell_error
    echo('Something went wrong: '. l:executionResult)
  else
    call s:RefreshBuffers(l:executionResult)
  endif
endfunction

function! s:RefreshBuffers(output)
  let l:parsed_response = json_decode(a:output)
  let l:current_bufnum = bufnr('%')

  for l:file in l:parsed_response.changed
    let l:bufnum = s:FindBufNum(l:file)
    if l:bufnum != -1
      execute 'checktime '.l:bufnum
    endif
  endfor

  for l:file in l:parsed_response.removed
    let l:bufnum = s:FindBufNum(l:file)
    if l:bufnum != -1
      execute 'bdelete '.l:bufnum
    endif
  endfor

  for l:file_pair in l:parsed_response.renamed
    let l:bufnum = s:FindBufNum(l:file_pair[0])
    if l:bufnum != -1
      if l:bufnum == l:current_bufnum
        execute 'e '.l:file_pair[1]
      endif
      execute 'bdelete '.l:bufnum
    endif
  endfor
endfunction

function! s:FindBufNum(file)
  let l:fileRegex = a:file.'$'
  return bufnr(l:fileRegex)
endfunction


command! -nargs=* Reruby :call <SID>RunRefactor(<f-args>)

