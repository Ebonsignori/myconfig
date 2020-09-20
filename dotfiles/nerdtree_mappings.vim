" Allow moving up/down windows in Nerdtree
augroup my_nerdtree
    au!
    au FileType nerdtree nnoremap <buffer> <C-j> <C-w>j
    au FileType nerdtree nnoremap <buffer> <C-j> <C-w>k
augroup END
