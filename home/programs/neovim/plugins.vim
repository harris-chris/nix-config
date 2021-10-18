
" airline: status bar at the bottom
let g:airline_powerline_fonts=1

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" bufkill
nnoremap <leader>q :BD<cr>

" Telescope
nnoremap <leader><space> <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>a <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" nvim-lspconfig
lua << EOF
require'lspconfig'.hls.setup{}
require'lspconfig'.ccls.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.metals.setup{}
require'lspconfig'.svls.setup{}
EOF

" Nerdtree
map <C-F> :NERDTreeToggle<CR>
map <C-S> :NERDTreeFind<CR>

" Nerd commenter
filetype plugin on

" vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala
