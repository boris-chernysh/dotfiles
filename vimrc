" if vim-plug is not installed install it!
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" plugins list
call plug#begin('~/.vim/plugged')
Plug 'kshenoy/vim-signature' "marks helpers
Plug 'tpope/vim-fugitive' "git aliases
Plug 'tpope/vim-commentary' "commentary helpers
Plug 'tpope/vim-surround' "brackets helpers
Plug 'Lokaltog/vim-easymotion' "navigation in files
Plug 'mattn/emmet-vim' "fast creating html/css
Plug 'sjl/gundo.vim' "tree of file changes
Plug 'Raimondi/delimitMate' "brackets autoclose
Plug 'mhinz/vim-grepper' "find in filex
Plug 'skywind3000/asyncrun.vim' "async run shell commands
Plug 'ctrlpvim/ctrlp.vim' "open buffers and files
Plug 'd11wtq/ctrlp_bdelete.vim' "delete buffers from ctrlp
Plug 'moll/vim-bbye' "close buffers without close window
Plug 'benekastah/neomake' "async make tool
Plug 'webdevel/tabulous' "customazible tab line
" colors and helpers for languages
Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-markdown'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'digitaltoad/vim-jade'
" colorschemes
Plug 'reedes/vim-colors-pencil'
Plug 'jonathanfilip/vim-lucius'
call plug#end()

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
set laststatus=0 "hide statusline
set colorcolumn=81 "border for code
set clipboard=unnamed "system clipboard
set mouse=a "enable mouse for all modes
set hidden "hide buffer instead close
set splitbelow "new buffers position
set splitright "new buffers position
set number "number of current line
set relativenumber "relative numbers for other lines
set list "empty characters highlight
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~"
set t_Co=256 "terminal colors

" use spaces instead tabs
autocmd FileType javascript setlocal expandtab
autocmd FileType css setlocal expandtab
autocmd FileType less setlocal expandtab

" netrw
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_localrmdir='rm -r'
nnoremap <leader>. :Explore<CR>

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
" window bindings
nnoremap <leader>q :quit<CR>
" fast work with vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Gvim
if has('gui_running')
	set guioptions-=T
	set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
endif

colorscheme pencil " also may be used 'lucius'
set background=dark

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

" delete buffer without close window
nnoremap <leader>w :Bdelete<CR>
" show/hide gundo window
nnoremap <leader>g :GundoToggle<CR>
" instead !
nnoremap <leader>r :AsyncRun<Space>
" find something
nnoremap <leader>f :Grepper -query<Space>
" find word under cursor
nnoremap <Leader>F :Grepper -query <cword><CR>
" buffers navigation
nnoremap <leader>b :CtrlPBuffer<CR>

let g:grepper = {}
let g:grepper.tools = ['ag', 'git', 'grep'] " use ag if exists, or use git grep, or just grep

let g:ctrlp_types = ['fil', 'buf'] " use only file and buffers search
let g:ctrlp_lazy_update = 1 " 250ms debouncing
call ctrlp_bdelete#init() " init plugin for delete buffers from ctrlp

" neomake
let g:jsx_ext_required = 0 "allow jsx in normal js files
autocmd FileType javascript,less,css call SetNeomakers() " set local npm makers
autocmd! BufWritePost,BufEnter * Neomake


" use silver searcher
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor

	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_use_caching = 0
endif

" utils

" SetLinters() sets Neomake variables for project linting engines
" if ./node_modules/.bin not set in $PATH binaries for makers not be found, and
" Neomake won't use it
function! SetNeomakers()
	let l:npm_bin = GetNpmBinFolder()
	let l:js_makers = []
	let l:style_makers = []

	if strlen(l:npm_bin)
		if executable(l:npm_bin . '/eslint')
			call add(l:js_makers, 'eslint')
			let b:neomake_javascript_eslint_exe = l:npm_bin . '/eslint'
		elseif executable(l:npm_bin . '/jshint')
			call add(l:js_makers, 'jshint')
			let b:neomake_javascript_jshint_exe = l:npm_bin . '/jshint'
		endif

		if executable(l:npm_bin . '/stylelint')
			call add(l:style_makers, 'stylelint')
			let b:neomake_less_stylelint_exe = l:npm_bin . '/stylelint'
			let b:neomake_css_stylelint_exe = l:npm_bin . '/stylelint'
		endif
	endif

	let b:neomake_javascript_enabled_makers = l:js_makers
	let b:neomake_jsx_enabled_makers = l:js_makers
	let b:neomake_less_enabled_makers = l:style_makers
	let b:neomake_css_enabled_makers = l:style_makers
endfunction

" get folder where npm store bin
function! GetNpmBinFolder()
	let l:npm_bin = ''

	if executable('npm')
		let l:npm_bin = split(system('npm bin'), '\n')[0]
	endif

	return l:npm_bin
endfunction
