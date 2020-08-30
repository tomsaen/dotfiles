call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-sensible'
Plug 'bronson/vim-trailing-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NerdTreeToggle' }

call plug#end()

set background=light
try
    solarized_termcolors=256
    colorscheme solarized
catch
endtry

let python_highlight_all=1
syntax on

if (exists('+colorcolumn'))
    set colorcolumn=79
    highlight ColorColumn ctermbg=9
endif

nnoremap <silent> <C-l> :nohl<CR><C-l>

au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
    \ match BadWhitespace /\s\+$/

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

set encoding=utf-8
set number

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
autocmd StdinReadPre * let s:std_in=2
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif


" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
map <C-n> :NERDTreeToggle<CR>
map ; :Files<CR>
