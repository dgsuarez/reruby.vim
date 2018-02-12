if exists('g:loaded_reruby')
  finish
endif
let g:loaded_reruby = 1

function! s:RunRefactor(subcmd, ...)
  let l:current_line = getpos(".")[1]
  let l:file_name = @%
  let l:rest_args = join(a:000)
  let l:stderr_file = tempname()

  let l:command = 'reruby '.a:subcmd.' --report json -l '.l:file_name.':'.l:current_line.' '.l:rest_args.' 2> '.l:stderr_file
  let l:execution_result = system(l:command)


  if v:shell_error
    call s:PrintError(l:stderr_file)
  else
    call s:RefreshBuffers(l:execution_result)
  endif

  call delete(l:stderr_file)
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
  let l:file_regex = a:file.'$'
  return bufnr(l:file_regex)
endfunction

function! s:PrintError(stderr_file)
  let l:error = join(readfile(a:stderr_file), "\n   ")
  echohl ErrorMsg
  echo("Something went wrong, output of reruby: \n\n   ".l:error)
  echohl None
endfunction


command! -nargs=* Reruby :call <SID>RunRefactor(<f-args>)

