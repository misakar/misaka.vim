function! HelloMisaka()
    echo "Hello Misaka"

endfunction
command! -nargs=0 HelloMisaka call HelloMisaka()
