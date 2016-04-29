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
set mouse=a
set acd

set t_Co=256
set t_Sf=[3%dm
set t_Sb=[4%dm

let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_localrmdir='rm -r'

syntax on

au BufWrite /private/tmp/crontab.* set nowritebackup
au BufWrite /private/etc/pw.* set nowritebackup

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'pangloss/vim-javascript'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'othree/html5.vim'
Plugin 'buftabs'
Plugin 'ap/vim-css-color'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'dag/vim2hs'
Plugin 'tpope/vim-markdown'
Plugin 'briancollins/vim-jst'
Plugin 'juvenn/mustache.vim'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'zah/nimrod.vim'
Plugin 'mattn/emmet-vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'Raimondi/delimitMate'
Plugin 'mattn/webapi-vim.git'
Plugin 'moll/vim-node'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sjl/gundo.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'shutnik/jshint2.vim'
Plugin 'digitaltoad/vim-jade'
" Plugin 'jelera/vim-javascript-syntax'
" Plugin 'nono/jquery.vim'
" Plugin 'LaTeX-Box-Team/LaTeX-Box'
" Plugin 'shougo/vimproc'
" Plugin 'Shougo/vimshell.vim'
" Plugin 'jistr/vim-nerdtree-tabs'
" Plugin 'scrooloose/nerdtree.git'

call vundle#end()
filetype plugin indent on

"pangloss/vim-javascript
:set regexpengine=1
:syntax enable

" autocmd vimenter * NERDTree
" let g:nerdtree_tabs_open_on_console_startup=1

"easy motion
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

"colors
syntax enable
colorscheme lucius
set background=dark

"tabline colors
hi TabLine      ctermfg=Black  ctermbg=241 cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=235 cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=30 cterm=NONE

"lightline

let g:lightline = {'colorscheme': 'jellybeans'}

"empty characters highlight
set laststatus=2
set list
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~"

"use complcache
let g:neocomplcache_enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"not use complcache for html
if has('autocmd')
	autocmd FileType html nested NeoComplCacheLock
endif

set clipboard=unnamed

"es6 bind to js filetype
autocmd BufRead,BufNewFile *.es6,*.js setfiletype javascript

"nim filetype
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

let g:user_emmet_settings = webapi#json#decode(join(readfile(expand('~/dotfiles/snippets_emmet.json')), "\n"))

" strings numbering
set relativenumber
set number

function! ChangeNumbering()
	set relativenumber!
endfunction

function! OpenExplorer()
	if strlen(@%)
		exe "tabnew +Explore"
	else
		exe "Explore"
	endif
endfunction

"my mappings
map <F7> :!reset<CR>

nmap <silent> ;z :sh<CR>
nmap <silent> ;e :call OpenExplorer()<CR>
nmap <silent> ;. :Explore<CR>
" nmap <silent> ;s :call ChangeNumbering()<CR>
nmap <silent> ;w :tabclose<CR>
nmap <silent> ;q :q<CR>
nmap <silent> ;t :tabnew<CR>
" nmap <silent> ;e :tabnew +terminal<CR>
nmap <silent> ;g :GundoToggle<CR>
nmap <silent> ;r :GundoRenderGraph<CR>
nmap <silent> ;v :vnew <CR>
nmap <silent> ;s :new<CR>
"TODO: jshing must hint only js files (if filetype javascript)
nmap <silent> ;h :JSHint<CR>
nmap <silent> ;c :echo expand('%:p')<CR>
vmap <silent> ;y :w !xsel -i<CR><CR>
nmap <silent> ;p :read !xsel<CR>

function! ChangeBuf(cmd)
	execute a:cmd
endfunction
nnoremap <silent> <C-b> :call ChangeBuf(":bn")<CR>

vnoremap < <gv
vnoremap > >gv
