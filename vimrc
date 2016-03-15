set modelines=0
set encoding=utf-8
set nocompatible
set backspace=2
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=0
set number
set ruler
set showtabline=2
set colorcolumn=81

set t_Co=256
set t_Sf=[3%dm
set t_Sb=[4%dm

syntax on
au BufWrite /private/tmp/crontab.* set nowritebackup
au BufWrite /private/etc/pw.* set nowritebackup
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'pangloss/vim-javascript'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'itchyny/lightline.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/html5.vim'
Plugin 'nono/jquery.vim'
Plugin 'buftabs'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'ap/vim-css-color'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'shougo/vimproc'
Plugin 'Shougo/vimshell.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dag/vim2hs'
Plugin 'tpope/vim-markdown'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'StanAngeloff/php.vim'
Plugin 'briancollins/vim-jst'
Plugin 'juvenn/mustache.vim'
Plugin 'scrooloose/nerdtree.git'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'nanotech/jellybeans.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'zah/nimrod.vim'
Plugin 'mattn/emmet-vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'Raimondi/delimitMate'
Plugin 'mattn/webapi-vim.git'
Plugin 'FuzzyFinder'
Plugin 'moll/vim-node'
Plugin 'javacomplete'
Plugin 'tfnico/vim-gradle'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

let g:EasyMotion_do_mapping = 0

nmap <leader><leader> <Plug>(easymotion-s)
map  / <Plug>(easymotion-sn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

let g:EasyMotion_smartcase = 1

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0

function! ChangeBuf(cmd)
	execute a:cmd
endfunction
nnoremap <silent> <C-b> :call ChangeBuf(":bn")<CR>

syntax enable
colorscheme lucius
" colorscheme Tomorrow-Night-Eighties
set background=dark

hi TabLine      ctermfg=Black  ctermbg=241 cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=235 cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=30 cterm=NONE

" autocmd vimenter * NERDTree
let g:nerdtree_tabs_open_on_console_startup=1

set mouse=a

vnoremap < <gv
vnoremap > >gv


let g:neocomplcache_enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'fugitive', 'filename' ] ]
			\ },
			\ 'component_function': {
			\   'fugitive': 'MyFugitive',
			\   'readonly': 'MyReadonly',
			\   'modified': 'MyModified',
			\   'filename': 'MyFilename'
			\ },
			\ 'separator': { 'left': '⮀', 'right': '⮂' },
			\ 'subseparator': { 'left': '⮁', 'right': '⮃' }
			\ }

" 'separator': { 'left': '⮀', 'right': '⮂' },
" 'subseparator': { 'left': '⮁', 'right': '⮃' }

function! MyModified()
	if &filetype == "help"
		return ""
	elseif &modified
		return "+"
	elseif &modifiable
		return ""
	else
		return ""
	endif
endfunction
function! MyReadonly()
	if &filetype == "help"
		return ""
	elseif &readonly
		return "⭤"
	else
		return ""
	endif
endfunction

function! MyFugitive()
	if exists("*fugitive#head")
		let _ = fugitive#head()
		return strlen(_) ? '⭠ '._ : ''
	endif
	return ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

set laststatus=2
set list
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~"

if has('autocmd')
	autocmd FileType html nested NeoComplCacheLock
endif

set clipboard=unnamedplus
autocmd BufRead,BufNewFile *.es6,*.js setfiletype javascript

autocmd BufRead,BufNewFile *.nim setfiletype nim
autocmd FileType nim set tabstop=4|set shiftwidth=4|set expandtab

fun! JumpToDef()
	if exists("*GotoDefinition_" . &filetype)
		call GotoDefinition_{&filetype}()
	else
		exe "norm! \<C-]>"
	endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

let g:user_emmet_settings = webapi#json#decode(join(readfile(expand('~/.snippets_emmet.json')), "\n"))

" strings numbering
set relativenumber
set number

function! ChangeNumbering()
	set relativenumber!
endfunction
nmap <silent> ;s :call ChangeNumbering()<CR>
map <F7> :!reset<CR>
nmap <silent> ;w :tabclose<CR>
nmap <silent> ;t :tabnew<CR>
nmap <silent> ;e :tabnew +terminal<CR>
