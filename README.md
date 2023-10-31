# vim-vsnip-toml

Write vsnip snippets in toml.

## Motivation
[vsnip](https://github.com/hrsh7th/vim-vsnip) is awesome, but it's hard for human to write snippets in json format...

## Installation

```vim
call minpac#add('tatsuya4559/vim-vsnip-toml')
```

## Usage

Specify toml snippet directory in your .vimrc.

```vim
let g:vsnip_snippet_src_dir = '~/.vim/vsnip/toml'
```

Open some file and invoke `:VsnipEditTOML` command.
Then you can write snippets in toml format.

```toml
[[snippet]]
prefix = 'fn'
description = 'vimscript function'
body = '''
function! $1($2) abort
	$3
endfunction
'''
```

When you save the file, vsnip style json will be created under `g:vsnip_snippet_dir` directory.
