let g:ale_disable_lsp = 1

call plug#begin('~/.config/nvim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/indentpython.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/fzf', { 'do': { ->fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NerdTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-test/vim-test'
Plug 'liuchengxu/vista.vim'
"Plug 'arcticicestudio/nord-vim'
call plug#end()

set background=light
try
    "colorscheme nord
    colorscheme solarized
catch
endtry

"Airline theme
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let python_highlight_all=1

syntax on
if (exists('+colorcolumn'))
    set colorcolumn=88
    highlight ColorColumn ctermbg=9
endif

au BufNewFile, BufRead *.py
    \ set textwidth=88
    \ set autoindent
    \ set fileformat=unix
    \ match BadWhitespace /\s\+$/

au BufNewFile, BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

set encoding=utf-8
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
autocmd StdinReadPre * let s:std_in=2
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Use persistent history.
set undofile

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
nmap dil ^d$

" Vista
nnoremap <leader>t :Vista<cr>

" FZF
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>g :RG<cr>

" NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDTreeMinimalUI=1
let NERDTreeArrows=1
map <F1> :NERDTreeToggle<cr>
map <F2> :NERDTreeFind<cr>

" Panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" CoC
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" ALE
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {'python': ['pylint']}
let g:ale_fixers = {
\ 'python': ['black', 'isort'],
\'*': ['remove_trailing_lines', 'trim_whitespace']
\}

let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = "E"
let g:ale_echo_msg_warning_str = "W"
let g:ale_echo_msg_format = "[%linter%] %s [%severity%]"

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

" vim-test
let test#strategy = "neovim"
nmap <silent> <F9> :TestNearest<CR>
nmap <silent> <F10> :TestFile<CR>
nmap <silent> <F11> :TestSuite<CR>

" Allow for project based configuration
set exrc
set secure
