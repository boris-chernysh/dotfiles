" plug autoinstall {{{

if has('nvim')
	let g:plug_path = "~/.config/nvim/autoload/plug.vim"
else
	let g:plug_path = "~/.vim/autoload/plug.vim"
endif

if empty(glob(g:plug_path))
	execute '!curl -fLo ' . g:plug_path . ' --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
" }}}

" plugins list {{{
call plug#begin('~/.vim/plugged')
Plug 'kshenoy/vim-signature' "marks helpers
Plug 'tpope/vim-fugitive' "git aliases
Plug 'tpope/vim-commentary' "commentary helpers
Plug 'tpope/vim-surround' "brackets helpers
Plug 'Lokaltog/vim-easymotion' "navigation in files
Plug 'mattn/emmet-vim' "fast creating html/css
Plug 'Raimondi/delimitMate' "brackets autoclose
Plug 'mhinz/vim-grepper' "find in files
Plug 'neomake/neomake' "async make tool
Plug 'webdevel/tabulous' "customazible tab line
Plug 'dag/vim2hs' "haskell helpers
Plug 'editorconfig/editorconfig-vim' "use .editorconfig for projects
Plug 'Quramy/tsuquyomi' "typescript IDE features
" colors and helpers for languages
Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-markdown'
Plug 'mxw/vim-jsx'
" Plug 'moll/vim-node'
Plug 'digitaltoad/vim-jade'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
" colorschemes
Plug 'reedes/vim-colors-pencil'
Plug 'jonathanfilip/vim-lucius'
Plug 'nightsense/forgotten'
" buffers
Plug 'ctrlpvim/ctrlp.vim' "open buffers and files
Plug 'd11wtq/ctrlp_bdelete.vim' "delete buffers from ctrlp
Plug 'moll/vim-bbye' "close buffers without close window
Plug 'vim-scripts/BufOnly.vim' "close buffers except current one
call plug#end()
" }}}

" options {{{
let $PATH .= ':./node_modules/.bin/' "extend PATH for using local npm binaries
let mapleader = ';' "set leader
set encoding=utf-8 "characters encoding inside vim
set modelines=0 "disable modelines
set backspace=2 "allow backspacing over autoident, breaks and the starts of insert
set smartindent "automaticaly set right indent
set tabstop=4 "number of spaces in tab
set shiftwidth=4 "number of spaces for each ident level
set softtabstop=4 "count of spaces for show tab
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

" use spaces instead tabs
augroup expandtab
	autocmd!
	autocmd FileType haskell call SetHaskellOptions()
	autocmd FileType javascript,css,less,haskell setlocal expandtab
augroup END
" set marker fold method for vim script
autocmd! FileType vim setlocal foldmethod=marker
" }}}

" statusline {{{
set statusline=\ %{fugitive#statusline()}
set statusline+=\ <%{GetFilePath()}>
set statusline+=%=
set statusline+=%c:%l\ %L\ 
" }}}

" colors {{{
colorscheme pencil " also may be used 'lucius'
set background=dark
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
" cure terminal
noremap <F7> :!reset<CR>
" go to shell
nnoremap <leader>z :sh<CR>
" show full path for current file
nnoremap <leader>c :echo expand('%:p')<CR>
" tabs bindings
nnoremap <leader>W :tabclose<CR>
nnoremap <leader>T :tabnew<CR>
" delete buffer without close window
nnoremap <leader>ww :Bdelete<CR>
" delete all buffers except current one
nnoremap <leader>wa :BufOnly<CR>
" window bindings
nnoremap <leader>q :quit<CR>
nnoremap <leader>wq :bd<CR>
" fast work with vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" show/hide gundo window
nnoremap <leader>g :GundoToggle<CR>
" instead !
nnoremap <leader>r :AsyncRun<Space>
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
let g:grepper = {}
let g:grepper.tools = ['ag', 'git', 'grep'] " use ag if exists, or use git grep, or just grep
let g:grepper.highlight = 1
let g:grepper.prompt = 0
" }}}

" ctrlp {{{
let g:ctrlp_types = ['fil', 'buf'] " use only file and buffers search
let g:ctrlp_lazy_update = 1 " 250ms debouncing
let g:ctrlp_match_window = 'order:ttb'
let g:ctrlp_switch_buffer = 'Et'
call ctrlp_bdelete#init() " init plugin for delete buffers from ctrlp
" }}}

" Gvim {{{
if has('gui_running')
	set guioptions-=T
	set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
endif
" }}}

" neomake {{{
let g:jsx_ext_required = 0 "allow jsx in normal js files

let g:js_makers = ['eslint']
let g:style_makers = ['stylelint']
let g:ts_makers = ['tslint', 'tsc']
let g:neomake_javascript_enabled_makers = g:js_makers
let g:neomake_jsx_enabled_makers = g:js_makers
let g:neomake_less_enabled_makers = g:style_makers
let g:neomake_css_enabled_makers = g:style_makers
let g:neomake_typescript_enabled_makers = g:ts_makers
let g:neomake_tsx_enabled_makers = g:ts_makers

autocmd BufWritePost,BufEnter * Neomake
" }}}

" silver searcher {{{
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor

	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_use_caching = 0
endif
" }}}

" utils {{{

" write file with sudo
command! -nargs=0 -bang Wsudo :silent! w !sudo tee % &>/dev/null

function! SetHaskellOptions()
	setlocal tabstop=8
	setlocal shiftwidth=8
	setlocal softtabstop=8
endfunction

function! GetFilePath()
	" return path to file relative to current dir
	return expand('%:.:h')
endfunction
" }}}

