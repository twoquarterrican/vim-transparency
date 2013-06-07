" vim: foldmethod=marker
" Vim global plugin for making gvim transparent in windows
" Maintainer: Justin Thomas

if exists("g:loaded_vim_transparency")
	finish
endif
let g:loaded_vim_transparency = 1

" VimTweak utility function {{{1
function s:Vimtweak(option, value)
	if filereadable(expand("$VIMRUNTIME/vimtweak.dll"))
		call libcallnr("vimtweak.dll", a:option, a:value)
	else
		echom "put vimtweak.dll in the same directory as vim.exe or gvim.exe"
	endif
endfunction

" transparency {{{1

" initialize script Variables {{{2
let s:alpha_step = 20
let s:alpha = 235

" main transparency functions {{{2 
function MakeLessTransparent()
	call s:Change_transparency(-s:alpha_step)
endfunction

function MakeMoreTransparent()
	call s:Change_transparency(s:alpha_step)
endfunction

" helper transparency functions{{{3

function s:Change_transparency(amount)
	call s:Compute_and_store_transparency(a:amount)
	call s:Vimtweak("SetAlpha", s:alpha)
endfunction

function s:Compute_and_store_transparency(amount)
	let s:alpha += a:amount
	call s:Ensure_alpha_within_range()
endfunction
	
function s:Ensure_alpha_within_range()
	if s:alpha < s:alpha_step
		let s:alpha = s:alpha_step
	elseif s:alpha > 255
		let s:alpha = 255
	endif
	echom "s:alpha is " . s:alpha
endfunction

" transparency mappings {{{2
nmap <F8> :call MakeLessTransparent()<CR>
nmap <F9> :call MakeMoreTransparent()<CR>

" Always on top {{{1
function Set_always_on_top()
	call s:Vimtweak('EnableTopMost', 1)
endfunction

function Unset_always_on_top()
	call s:Vimtweak('EnableTopMost', 0)
endfunction

" on top mappings {{{2
nmap <C-F9> :call Set_always_on_top()<CR>
nmap <c-F8> :call Unset_always_on_top()<CR>
