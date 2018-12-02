set background=dark
syntax on
nnoremap <silent> <C-l> :nohl<CR><C-l>

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set number

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
