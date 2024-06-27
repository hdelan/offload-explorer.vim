
" Initialization
if exists("g:loaded_offload_explorer") || &cp
  finish
endif

let g:loaded_offload_explorer = 1
" }}}

" Only run in normal mode
nnoremap <silent><Plug>OffloadExplorerShowPTX :<C-U>call offloadexplorer#ShowIR('ptx')<CR>
nnoremap <silent><Plug>OffloadExplorerShowCudaIR :<C-U>call offloadexplorer#ShowIR('nvbc')<CR>
nnoremap <silent><Plug>OffloadExplorerShowAMDHSA :<C-U>call offloadexplorer#ShowIR('hsa')<CR>
nnoremap <silent><Plug>OffloadExplorerShowAmdIR :<C-U>call offloadexplorer#ShowIR('amdbc')<CR>

" Default mappings
nnoremap <silent><leader>cc <Plug>OffloadExplorerShowPTX
nnoremap <silent><leader>bc <Plug>OffloadExplorerShowCudaIR
nnoremap <silent><leader>ac <Plug>OffloadExplorerShowAMDHSA
nnoremap <silent><leader>abc <Plug>OffloadExplorerShowAmdIR

" Variables
let g:offload_explorer_cxx = get(g:, 'g:offload_explorer_cxx', 'clang++')
let g:offload_explorer_amd_arch = get(g:, 'g:offload_explorer_amd_arch', 'gfx906')
