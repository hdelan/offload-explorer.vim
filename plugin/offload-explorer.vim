" Only run in normal mode
nnoremap <silent><Plug>OffloadExplorerShowPTX :call offloadexplorer#ShowIR("ptx")<CR>
nnoremap <silent><Plug>OffloadExplorerShowCudaIR :call offloadexplorer#ShowIR("nvbc")<CR>

" Default mappings
nnoremap <silent><leader>cc <Plug>OffloadExplorerShowPTX
nnoremap <silent><leader>bc <Plug>OffloadExplorerShowCudaIR

