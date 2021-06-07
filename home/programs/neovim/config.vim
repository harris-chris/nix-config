filetype off

let mapleader = " "
set shell=/run/current-system/sw/bin/fish

" Allow macros over visual selection
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Better Unix support
set viewoptions=folds,options,cursor,unix,slash
set encoding=utf-8

" Stop the terminal buffer from automatically closing
:set hidden

" Remove line numbers from terminal
autocmd TermOpen * setlocal nonumber norelativenumber

" Handle window actions with Meta instead of <C-w>
" Moving
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing
nnoremap <C-=> <C-w>=
nnoremap <C-+> <C-w>+
nnoremap <C--> <C-w>-
nnoremap <C-<> <C-w><
nnoremap <C->> <C-w>>

" True color support
set termguicolors

" Theme
colorscheme iceberg

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

if has("nvim")
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  "au FileType fzf tunmap <buffer> <Esc>
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

nnoremap <C-p> :FZF<CR>

set guicursor=

" General options
set clipboard=unnamedplus
set number
set numberwidth=1
set completeopt+=noinsert

" Search
set incsearch
set ignorecase
set smartcase

" Spell check for markdown files
au BufNewFile,BufRead *.md set spell

" Disable the annoying and useless ex-mode
nnoremap Q <Nop>
nnoremap gQ <Nop>

" Disable background (let picom manage it)
hi Normal guibg=NONE ctermbg=NONE


