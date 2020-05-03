" plug autoinstall {{{

if has('nvim')
    let g:plug_path = "~/.config/nvim/autoload/plug.vim"
else
    let g:plug_path = "~/.vim/autoload/plug.vim"
endif

if empty(glob(g:plug_path))
    execute '!curl -fLo ' . g:plug_path . ' --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    source $MYVIMRC
    execute 'PlugInstall'
endif
" }}}

" plugins list {{{
call plug#begin('~/.vim/plugged')
Plug 'kshenoy/vim-signature' "marks helpers
Plug 'tpope/vim-fugitive' "git aliases
Plug 'tpope/vim-commentary' "commentary helpers
Plug 'tpope/vim-surround' "brackets helpers
Plug 'tpope/vim-eunuch' "unix commands helpers
Plug 'Lokaltog/vim-easymotion' "navigation in files
Plug 'mattn/emmet-vim' "fast creating html/css
Plug 'Raimondi/delimitMate' "brackets autoclose
Plug 'mhinz/vim-grepper' "find in files
Plug 'w0rp/ale' "make tool
Plug 'editorconfig/editorconfig-vim' "use .editorconfig for projects
Plug 'powerman/vim-plugin-ruscmd' "russian layout for NORMAL mode
" colors and helpers for languages
Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-markdown'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'quramy/tsuquyomi'
" colorschemes
Plug 'jonathanfilip/vim-lucius'
Plug 'altercation/vim-colors-solarized'
" buffers
Plug 'ctrlpvim/ctrlp.vim' "open buffers and files
Plug 'd11wtq/ctrlp_bdelete.vim' "delete buffers from ctrlp
Plug 'moll/vim-bbye' "close buffers without close window
Plug 'vim-scripts/BufOnly.vim' "close buffers except current one
call plug#end()
" }}}

" options {{{
let mapleader = ';' "set leader
set encoding=utf-8 "characters encoding inside vim
set backspace=2 "allow backspacing over autoident, breaks and the starts of insert
set smartindent "automaticaly set right indent
set tabstop=4 "number of spaces in tab
set shiftwidth=4 "number of spaces for each ident level
set softtabstop=4 "count of spaces for tab
set showtabline=2 "always show tabline
set scrolloff=5 "number of screen lines to keep above and below cursor
set laststatus=2 "always show statusline
set colorcolumn=81 "border for code
" use system clipboard
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif
set mouse=a "enable mouse for all modes
set hidden "hide buffer instead close
set splitbelow "new buffers position
set splitright "new buffers position
set number "number of current line
set relativenumber "relative numbers for other lines
set list "empty characters highlight
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~"
set t_Co=256 "terminal colors
set suffixesadd+=.js,.jsx,.ts,.tsx "open files without extension by gf
set expandtab " use spaces instead tabs
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby " ruby syntax for Vagrantfile
autocmd! FileType vim setlocal foldmethod=marker " set marker fold method for vim script
" }}}

" statusline {{{
set statusline=\ %{fugitive#statusline()}
set statusline+=\ <%{GetFilePath()}>
set statusline+=%=
set statusline+=%{LinterStatus()}
set statusline+=%c:%l\ %L\ 
" }}}

" colors {{{
colorscheme lucius " also may be used 'solarized'
set background=light
" }}}

" netrw {{{
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_localrmdir='rm -r'
" }}}

" mappings {{{
" move blocks in visual mode
vnoremap < <gv
vnoremap > >gv
" go to shell
nnoremap <leader>z :sh<CR>
" show full path for current file
nnoremap <leader>c :echo expand('%:p')<CR>
" tabs bindings
nnoremap <leader>T :tabnew<CR>
" delete buffer without close window
nnoremap <leader>wq :Bdelete<CR>
" delete all buffers except current one
nnoremap <leader>wa :BufOnly<CR>
" window bindings
nnoremap <leader>q :quit<CR>
nnoremap <leader>bq :bd<CR>
" fast work with vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" find something
nnoremap <leader>f q:iGrepper -query<Space>
nnoremap <leader>F :Grepper -cword<CR>
" buffers navigation
nnoremap <c-k> :CtrlPBuffer<CR>
" open netrw
nnoremap <leader>. :Explore<CR>
nnoremap <leader>yp :let @+ = expand("%")<CR>
nnoremap <leader>yn :let @+ = expand("%:t:r")<CR>
" always use the command editing window
nnoremap : q:i
vnoremap : q:i

nmap <silent> <leader>[ <Plug>(ale_previous_wrap)
nmap <silent> <leader>] <Plug>(ale_next_wrap)
nmap <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>
" }}}

" easy motion {{{
let g:EasyMotion_do_mapping = 0 " dont use default mapping
let g:EasyMotion_smartcase = 1 " ignore case
let g:EasyMotion_startofline = 0 " save cursor column when use easymoiton-(j|k)
let g:EasyMotion_use_smartsign_us = 1 " use smart sign like 2->@ on us layout
" replace standart search
map / <Plug>(easymotion-sn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
" navfigation lines
map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)
" }}}

" grepper {{{
let g:grepper = {
            \ 'tools': ['rg', 'ag', 'git', 'grep'],
            \ 'highlight': 1,
            \ 'prompt': 0,
            \ 'ag': {
            \   'grepprg': 'ag --vimgrep --hidden',
            \ },
            \ 'rg': {
            \   'grepprg': 'rg --vimgrep --hidden',
            \ },
            \}
" }}}

" ctrlp {{{
let g:ctrlp_types = ['fil', 'buf'] " use only file and buffers search
let g:ctrlp_lazy_update = 1 " 250ms debouncing
let g:ctrlp_match_window = 'order:ttb'
let g:ctrlp_switch_buffer = 'Et'
call ctrlp_bdelete#init() " init plugin for delete buffers from ctrlp
" }}}

" silver searcher {{{
if executable('ag')
    set grepprg=ag\ --vimgrep\ --hidden

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
endif
" }}}

" ripgrep {{{
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden

    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
endif
" }}}

" ale {{{
" error signs
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'

" do not highlight bg under ale signs
hi AleErrorSign cterm=none ctermfg=160 ctermbg=0
hi AleWarningSign cterm=none ctermfg=220 ctermbg=0

let g:ale_pattern_options = {
            \ '\.js$': {'ale_linters': ['eslint', 'jshint', 'flow']},
            \ '\.jsx$': {'ale_linters': ['eslint', 'flow']},
            \ '\.ts$': {'ale_linters': ['eslint', 'tslint', 'tsserver']},
            \ '\.tsx$': {'ale_linters': ['eslint', 'tslint', 'tsserver']},
            \}
let g:ale_pattern_options_enabled = 1

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
                \   '%d💩 %d☠️ ',
                \   all_non_errors,
                \   all_errors
                \)
endfunction

let g:ale_echo_msg_error_str = '☠️'
let g:ale_echo_msg_warning_str = '💩'
let g:ale_echo_msg_format = '%severity% (%linter%) %s'
" }}}

" utils {{{
function! GetFilePath()
    " return path to file relative to current dir
    return expand('%:.:h')
endfunction
" }}}

" {{{ tsuquyomi
let g:tsuquyomi_disable_quickfix = 1
set ballooneval
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
" }}}
