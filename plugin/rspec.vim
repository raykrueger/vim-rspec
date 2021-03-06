" Rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

let s:plugin_path = expand("<sfile>:p:h:h")

if has("gui_running") && has("gui_macvim")
  let g:rspec_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal 'rspec {spec}'"
else
  let g:rspec_command = "!echo rspec {spec} && rspec {spec}"
endif

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_command")
    call RunSpecs(s:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! RunSpecs(spec)
  write
  execute substitute(g:rspec_command, "{spec}", a:spec, "g")
endfunction
