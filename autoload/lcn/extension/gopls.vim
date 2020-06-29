" { command:string, arguments:any }
function! lcn#extension#gopls#execute_command(command) abort
  let l:command = json_decode(a:command)
  if !has_key(l:command, 'command')
    return
  endif

  let l:command_name = l:command['command']
  if l:command_name ==# 'test'
    return s:Test(l:command)
  elseif l:command_name ==# 'generate'
    return s:Generate(l:command)
  endif
endfunction

function! lcn#extension#gopls#supported_commands() abort
  return ['test', 'generate']
endfunction

" { command: \"generate\", arguments: [ package:string, recursive:bool ] }
function! s:Generate(command) abort
  if !has_key(a:command, 'arguments')
    return
  endif

  let l:arguments = a:command['arguments']
  let l:package = l:arguments[0]
  let l:recursive = l:arguments[1]
  if l:recursive
    execute('term go generate ./..')
  else
    execute('term go generate ' . l:package)
  endif
endfunction

" { command: \"test\", arguments: [ func:string, package:string ] }
function! s:Test(command) abort
  if !has_key(a:command, 'arguments')
    return
  endif

  let l:arguments = a:command['arguments']
  let l:func = l:arguments[0]
  let l:package = l:arguments[1]
    execute('term go test -run ' . l:func . ' ' . l:package)
  endif
endfunction
