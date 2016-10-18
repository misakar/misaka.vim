" ``````````````````````````````
"  ██╗   ██╗██╗███╗   ███╗
"  ██║   ██║██║████╗ ████║
"  ██║   ██║██║██╔████╔██║
"  ╚██╗ ██╔╝██║██║╚██╔╝██║
"   ╚████╔╝ ██║██║ ╚═╝ ██║
"    ╚═══╝  ╚═╝╚═╝     ╚═╝
"                         
"   learn viml the love way:)
"
" ``````````````````````````````

" version 7.3+ required
if v:version < '703'
    function! s:MisakaDidNotLoad()
        echohl WarningMsg|echomsg "your girl friend unavailable: requires Vim 7.3+"|echohl None
    endfunction
    command! -nargs=0 MisakaToggle call s:MisakaDidNotLoad()
    finish
endif

" misaka setting
if !exists('g:misaka_width')
    let g:misaka_width = 45
endif
if !exists('g:misaka_right')
    let g:misaka_right = 0
endif

" support python
let s:has_supported_python = 0
if has('python')
    let s:has_supported_python = 1
endif
if !s:has_supported_python
    function! s:MisakaDidNotLoad()
        echohl WarningMsg|echomsg "misaka requires Vim to be compiled with Python 2.4+"|echohl None
    endfunction
    command! -nargs=0 MisakaToggle call s:MisakaDidNotLoad()
    finish
endif

" misaka plugin path
let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

function! s:MisakaOpen()
    if !exists('g:misaka_py_loaded')
        if s:has_supported_python == 1
            exe 'pyfile ' . s:plugin_path . '/misaka.py'
            python initPythonModule()
        endif

        if !s:has_supported_python
            function! s:MisakaDidNotLoad()
                echohl WarningMsg|echomsg "your girl friend unavailable: requires Vim 7.3+"|echohl None
            endfunction
            command! -nargs=0 MisakaToggle call s:MisakaDidNotLoad()
            call s:MisakaDidNotLoad()
            return
        endif

        let g:misaka_py_loaded = 1 "python2 loaded!
    endif

    exe "vnew" 
    python HelloMisaka()
endfunction

function! s:MisakaGoToWindowForBufferName(name)
    if bufwinnr(bufnr(a:name)) != -1
        exe bufwinnr(bufnr(a:name)) . "wincmd w"
        return 1
    else
        return 0
    endif
endfunction

function! s:ByeMisaka()
    if s:GundoGoToWindowForBufferName('__Gundo__')
        quit
    endif
    exe bufwinnr(g:misaka_target_n) . "wincmd w"
endfunction

function! s:HelloMisaka()
    if s:has_supported_python == 1
        python HelloMisaka()
    endif
endfunction

" misaka buffer setting
function! s:Tokyo()
    setlocal buftype=nofile     "buffer which is not related to a file and will not be written
    setlocal bufhidden=hide     "hide the buffer (don't unload it), also when 'hidden' is not set
    setlocal noswapfile         "it will be loaded without creating a swapfile
    setlocal nobuflisted        "the buffer will not shows up in the buffer list
    setlocal nomodifiable       "the buffer can not be modified
    setlocal filetype=misaka    "misaka filetype:)
    setlocal nolist             "no list mode
    setlocal nonumber           "no line number
    setlocal norelativenumber   "no relative line number
    setlocal nowrap             "no line wrap
    call s:TokyoMapGraph()
endfunction

function! s:TokyoMapGraph()
    nnoremap <script> <silent> <buffer> P             :call <sid>HelloMisaka()<CR>
    nnoremap <script> <silent> <buffer> q             :call <sid>ByeMisaka()<CR>
    cabbrev  <script> <silent> <buffer> q             :call <sid>ByeMisaka()
    cabbrev  <script> <silent> <buffer> quit          :call <sid>ByeMisaka()
endfunction

function! s:MisakaIsVisible()
    if bufwinnr(bufnr("__Misaka__")) != -1
        return 1
    else
        return 0
    endif
endfunction

function! misaka#MisakaToggle()
    " if s:MisakaIsVisible()
    "     call s:ByeMisaka()
    " else
    "     let g:misaka_target_n = bufnr('')
    "     let g:misaka_target_f = @%
    "     call s:MisakaOpen()
    " endif
    let g:misaka_target_n = bufnr('')
    let g:misaka_target_f = @%
    call s:MisakaOpen()
endfunction

augroup MisakaAug
    autocmd!
    autocmd BufNewFile __Misaka__ call s:Tokyo()
augroup END
