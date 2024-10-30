" Initialization
if !exists("g:loaded_offload_explorer") || &cp
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Functions {{{
" TODO add variadic args for cuda gpu version
" TODO automatically compile in background on saving?
" TODO get support for -###
" TODO quickfix list
function! CreateTmpDir()
  let l:tmpfile = tempname()
  call mkdir(l:tmpfile, 'p')
  return l:tmpfile
endfunction

function! offloadexplorer#ShowIR(IRformat)
  let dpcpp_tmp_ir_folder = CreateTmpDir()

  if a:IRformat == "ptx" || a:IRformat == "nvbc"
    let targets = "nvidia_gpu_sm_60"
  elseif a:IRformat == "hsa" || a:IRformat == "amdbc"
    let targets = join(["amdgcn-amd-amdhsa -Xsycl-target-backend --offload-arch=", g:offload_explorer_amd_arch], "")
  elseif a:IRformat == "spir"
    let targets = "spir64-unknown-unknown"
  endif

  let working_file_full_path = expand('%:p')

  let base_command = join(["!cd ", dpcpp_tmp_ir_folder, " && ", g:offload_explorer_cxx, " -fsycl -Xclang -fsycl-range-rounding=disable -mllvm -enable-global-offset=false -fsycl-targets=", targets, " ", working_file_full_path], "")

  if a:IRformat == "nvbc" || a:IRformat == "amdbc" || a:IRformat == "spirbc"
    let IRfile_full_path = join([dpcpp_tmp_ir_folder, "/", fnamemodify(working_file_full_path, ":t"), ".ll"], "")
    exec join([base_command, " -fsycl-device-only -S -o ", IRfile_full_path], "")
    exec join(["vsp ", IRfile_full_path], "")
    return
  else
    exec join([base_command, " -save-temps"], "")
  endif

  if a:IRformat == "ptx"
    let ptxfile = trim(system(join(["grep PTX -l ", dpcpp_tmp_ir_folder, "/*"], "")))
    exec join(["vsp", ptxfile])
  elseif a:IRformat == "hsa"
    let hsafile = trim(system(join(["grep .amdhsa_code_object_version -l ", dpcpp_tmp_ir_folder, "/*.s"], "")))
    exec join(["vsp", hsafile])
  " TODO re-enable spir once this mess is fixed
  " elseif a:IRformat == "spir"
  "   let spirfile = trim(system(join(["head -n 1 ", dpcpp_tmp_ir_folder, "/*sycl-spir64-unknown-unknown-*.txt"], "")))
  "   echom join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
  "   exec join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
  "   exec join(["vsp ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
  endif
endfunction
" }}}

let &cpo = s:cpo_save
unlet s:cpo_save
