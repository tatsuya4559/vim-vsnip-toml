let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_vsnip_toml')
  finish
endif
let g:loaded_vsnip_toml = 1

augroup vsnip_toml_internal
  autocmd! *
  autocmd BufWritePost *.toml call vsnip_toml#transpile(expand('%:p'))
augroup END

command! -nargs=? VsnipEditTOML :call vsnip_toml#edit(<q-args>)

let &cpoptions = s:save_cpo
unlet s:save_cpo
