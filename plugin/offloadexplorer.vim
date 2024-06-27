
" Initialization
if exists("g:loaded_offload_explorer") || &cp
  finish
endif

let g:loaded_offload_explorer = 1
" }}}

" Only run in normal mode
nnoremap <silent><Plug>OffloadExplorerShowPTX :<C-U>call offloadexplorer#ShowIR('ptx')<CR>
nnoremap <silent><Plug>OffloadExplorerShowCudaIR :<C-U>call offloadexplorer#ShowIR('nvbc')<CR>

" Default mappings
nnoremap <silent><leader>cc <Plug>OffloadExplorerShowPTX
nnoremap <silent><leader>bc <Plug>OffloadExplorerShowCudaIR

" Variables
let g:offload_explorer_cxx = get(g:, 'g:offload_explorer_cxx,', 'clang++')
