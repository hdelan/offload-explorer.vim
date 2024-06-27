" Initialization
if exists("g:loaded_offload_explorer") || &cp
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Functions {{{
" TODO add variadic args for cuda gpu version
" TODO automatically compile in background on saving?
" TODO get support for -###
" TODO quickfix list
function! offloadexplorer#ShowIR(IRformat)
  let dpcpp_tmp_ir_folder = "/home/hugh/.tmp_ir"
  if !isdirectory(dpcpp_tmp_ir_folder)
    exec join(["!mkdir", dpcpp_tmp_ir_folder])
  elseif system(join(["ls ", dpcpp_tmp_ir_folder, " | wc -l"], "")) > 0
    exec join(["!rm -fr ", dpcpp_tmp_ir_folder, "/*"], "")
  endif

  if a:IRformat == "ptx" || a:IRformat == "nvbc"
    let targets = "nvptx64-nvidia-cuda"
  elseif a:IRformat == "spir"
    let targets = "spir64-unknown-unknown"
  endif

  let working_file = expand('%:p')

  exec join(["!cd ", dpcpp_tmp_ir_folder, " && clang++ -fsycl -Xclang -fsycl-disable-range-rounding -mllvm -enable-global-offset=false --save-temps -fsycl-targets=", targets, " ", working_file], "")

  if a:IRformat == "ptx"
    let ptxfile = trim(system(join(["grep PTX -l ", dpcpp_tmp_ir_folder, "/*"], "")))
    exec join(["vsp", ptxfile])
  elseif a:IRformat == "nvbc" || a:IRformat == "spirbc"
    let bcfile = split(systemlist(join(["grep \"clang\" ", dpcpp_tmp_ir_folder, "/* | grep \"Binary file.*sycl.*bc\""], ""))[0])[2]
    exec join(["!llvm-dis ", bcfile, " -o ", bcfile, ".ll"], "")
    exec join(["vsp ", bcfile, ".ll"], "")
  elseif a:IRformat == "spir"
    let spirfile = trim(system(join(["head -n 1 ", dpcpp_tmp_ir_folder, "/*sycl-spir64-unknown-unknown-*.txt"], "")))
    echom join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
    exec join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
    exec join(["vsp ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
  endif
  if system(join(["ls ", dpcpp_tmp_ir_folder, "/a.out | wc -l"], "")) > 0
    exec join(["!cp ", dpcpp_tmp_ir_folder, "/a.out ."], "")
  endif
endfunction
" }}}

let &cpo = s:cpo_save
unlet s:cpo_save
