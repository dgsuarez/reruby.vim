if exists('g:loaded_reruby')
  finish
endif
let g:loaded_reruby = 1

function! s:RunRefactor(start_line, end_line, subcmd, ...)
  let l:rest_args = join(a:000)
  let l:stderr_file = tempname()

  let l:location = s:FileWithPosition(a:start_line, a:end_line)

  let l:command = 'reruby '.a:subcmd.' --report json -l '.l:location.' '.l:rest_args.' 2> '.l:stderr_file
  let l:execution_result = system(l:command)


  if v:shell_error
  call s:PrintError(l:stderr_file)
  else
  call s:RefreshBuffers(l:execution_result)
  endif

  call delete(l:stderr_file)
endfunction

function! s:FileWithPosition(start_line, end_line)
  let l:file_name = @%
  if a:start_line > a:end_line
    let l:position_in_file = getpos(".")[1]
  else
    let [l:line_start, l:column_start] = getpos("'<")[1:2]
    let [l:line_end, l:column_end] = getpos("'>")[1:2]

    let l:column_start = l:column_start - 1
    let l:column_end = l:column_end - 1

    let l:position_in_file = l:line_start.':'.l:column_start.':'.l:line_end.':'.l:column_end
  endif

  return l:file_name.':'.l:position_in_file
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


command! -nargs=* -range=0 Reruby :call <SID>RunRefactor(<line1>, <line2>, <f-args>)

