let s:TOML = vital#vsnip_toml#import('Text.TOML')
let s:JSON = vital#vsnip_toml#import('Web.JSON')
let s:Filepath = vital#vsnip_toml#import('System.Filepath')

function! s:transpile(toml) abort
  let vsnip = {}
  for snip in a:toml.snippet
    let snip.body = snip.body->trim('', 2)->split('\n')
    let vsnip[snip.prefix] = snip
  endfor
  return vsnip
endfunction

function! s:get_snip_src_dir() abort
  let dir = get(g:, 'vsnip_snippet_src_dir', '')
  if dir ==# ''
    throw 'Please set g:vsnip_snippet_src_dir'
  endif
  return s:Filepath.abspath(s:Filepath.expand_home(dir))
endfunction

function! s:get_snip_out_dir() abort
  let dir = get(g:, 'vsnip_snippet_dir', '')
  if dir ==# ''
    throw 'Please set g:vsnip_snippet_dir'
  endif
  return s:Filepath.abspath(s:Filepath.expand_home(dir))
endfunction

function! s:echoerr() abort
  echohl ErrorMsg
  echo v:exception
  echo v:throwpoint
  echohl None
endfunction

function! vsnip_toml#transpile(file) abort
  try
    let src_dir = s:get_snip_src_dir()
  catch
    call s:echoerr()
    return
  endtry

  "return if the file is not snippet src
  if !s:Filepath.contains(a:file, src_dir)
    if get(g:, 'vsnip_toml_debug')
      echom printf('Not a snippet source: %s', a:file)
      echom src_dir
    endif
    return
  endif

  try
    let out_dir = s:get_snip_out_dir()
  catch
    call s:echoerr()
    return
  endtry
  let filetype = fnamemodify(a:file, ':t:r')
  let out_path = s:Filepath.join(out_dir, printf('%s.json', filetype))

  let toml = s:TOML.parse_file(a:file)
  let vsnip = s:transpile(toml)
  call writefile([s:JSON.encode(vsnip)], out_path)
endfunction

function! vsnip_toml#edit(filetype) abort
  try
    let snip_src_dir = s:get_snip_src_dir()
  catch
    call s:echoerr()
    return
  endtry

  let filetype = empty(a:filetype) ? &filetype : a:filetype
  if empty(filetype)
    echom 'No filetype detected.'
    return
  endif
  let snip_src = s:Filepath.join(snip_src_dir, printf('%s.toml', filetype))
  exe 'edit' snip_src
endfunction
