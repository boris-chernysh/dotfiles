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
nmap <leader>. :Explore<CR>

" move blocks in visual mode
vnoremap < <gv
vnoremap > >gv
" cure terminal
map <F7> :!reset<CR>
" go to shell
nmap <leader>z :sh<CR>
" show full path for current file
nmap <leader>c :echo expand('%:p')<CR>
" tabs bindings
nmap <leader>W :tabclose<CR>
nmap <leader>T :tabnew<CR>
" window bindings
nmap <leader>q :quit<CR>

" Gvim
if has('gui_running')
	set guioptions-=T
	set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
endif

call plug#begin('~/.vim/plugged')

Plug 'kshenoy/vim-signature' "marks helpers
Plug 'tpope/vim-fugitive' "git aliases
Plug 'tpope/vim-commentary' "commentary helpers
Plug 'tpope/vim-surround' "brackets helpers
Plug 'Lokaltog/vim-easymotion' "navigation in files
Plug 'mattn/emmet-vim' "fast creating html/css
Plug 'sjl/gundo.vim' "tree of file changes
Plug 'Raimondi/delimitMate' "brackets autoclose
Plug 'mileszs/ack.vim' "find in files
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

colorscheme pencil
set background=dark

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_use_smartsign_us = 1
map  / <Plug>(easymotion-sn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

nmap <leader>w :Bdelete<CR>
nmap <leader>g :GundoToggle<CR>
nmap <leader>r :AsyncRun<Space>
nmap <leader>f :Ack!<Space>
nmap <Leader>F :Ack! <cword><CR>

nmap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_types = ['fil', 'buf']
let g:ctrlp_lazy_update = 1
call ctrlp_bdelete#init()

" use ag for ctrlp and ack
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor

	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_use_caching = 0
	let g:ackprg = 'ag --vimgrep'
endif

" neomake
let g:jsx_ext_required = 0 "allow jsx in normal js files

autocmd FileType javascript,less,css call SetNeomakers()
autocmd! BufWritePost,BufEnter,TextChanged,TextChangedI * Neomake
autocmd FileType **/__tests__/*.js nmap <F9> Neomake! jest

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
