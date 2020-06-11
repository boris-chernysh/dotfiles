" plug autoinstall {{{

if has('nvim')
    let g:plug_path = '~/.config/nvim/autoload/plug.vim'
else
    let g:plug_path = '~/.vim/autoload/plug.vim'
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
Plug 'w0rp/ale' "make tool
Plug 'editorconfig/editorconfig-vim' "use .editorconfig for projects
Plug 'powerman/vim-plugin-ruscmd' "russian layout for NORMAL mode
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "fuzzy search via lists
Plug 'junegunn/fzf.vim'
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
Plug 'reedes/vim-colors-pencil'
" buffers
Plug 'moll/vim-bbye' "delete buffer without close window
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
let s:swpdir = $HOME.'/.vim/swapfiles/'
if isdirectory(s:swpdir)
    let &directory = s:swpdir
endif
" }}}

" statusline {{{
set statusline=\ %{fugitive#statusline()}
set statusline+=\ <%{GetFilePath()}>
set statusline+=%=
set statusline+=%{LinterStatus()}
set statusline+=%c:%l\ %L\ 
" }}}

" colors {{{
colorscheme pencil " also may be used 'lucius'
set background=dark
" }}}

" netrw {{{
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_localrmdir = 'rm -r'
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
nnoremap <leader>f :Grep<CR>
nmap <leader>F :execute 'Grep '.expand('<cword>')<CR>
" find files by name
nmap <c-p> :call <sid>Files()<CR>
" open changed files
nmap <c-g>p :GFiles?<CR>
" search in open buffers
map <leader>/ :Lines<CR>
" buffers navigation
nnoremap <c-b> :Buffers<CR>
" open netrw
nnoremap <leader>. :Explore<CR>
nnoremap <leader>yp :let @+ = expand('%')<CR>
nnoremap <leader>yn :let @+ = expand('%:t:r')<CR>
" always use the command editing window
nnoremap : q:i
vnoremap : q:i

nmap <silent> <leader>[ <Plug>(ale_previous_wrap)
nmap <silent> <leader>] <Plug>(ale_next_wrap)
nmap <Leader>bg :let &background = ( &background == 'dark'? 'light' : 'dark' )<CR>
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

" fzf {{{
" open fzf in modal window
if has('nvim-0.4.0') || has('patch-8.2.0191')
    let g:fzf_layout = { 'window': {
        \ 'width': 0.9,
        \ 'height': 0.7,
        \ 'highlight': 'Comment',
        \ 'rounded': v:false } }
endif

if $FZF_DEFAULT_COMMAND == ''
    let s:fzf_find_comand = 'find * -type f'
    let $FZF_DEFAULT_COMMAND = s:fzf_find_comand

    if executable('rg')
        let $FZF_DEFAULT_COMMAND = 'rg . --files --color=never --glob ""'
    endif
endif

function! s:Files()
    if $FZF_DEFAULT_COMMAND != s:fzf_find_comand || fugitive#head() == ''
        execute 'Files'
    else
        execute 'GFiles'
    endif
endfunction

function! s:Grep(query, fullscreen)
    if executable('rg')
        let command = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command, shellescape(a:query))
        let reload_command = printf(command, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    elseif fugitive#head() != ''
        call fzf#vim#grep(
                    \   'git grep --line-number -- '.shellescape(a:query), 0,
                    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), a:fullscreen)
    else
        call fzf#vim#grep(
                    \   'grep --line-number '.shellescape(a:query).' **/*', 0,
                    \   fzf#vim#with_preview({}), a:fullscreen)
    endif
endfunction

command! -nargs=* -bang Grep call s:Grep(<q-args>, <bang>0)
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

" kitty {{{
" fix scrolling bug in kitty https://github.com/kovidgoyal/kitty/issues/108
let &t_ut=''
" }}}
