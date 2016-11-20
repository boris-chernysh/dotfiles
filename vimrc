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
set hidden
set splitbelow
set splitright

autocmd FileType javascript setlocal expandtab
autocmd FileType css setlocal expandtab
autocmd FileType less setlocal expandtab

" set terminal colors
set t_Co=256
set t_Sf=[3%dm
set t_Sb=[4%dm

" netrw
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_localrmdir='rm -r'

syntax on

au BufWrite /private/tmp/crontab.* set nowritebackup
au BufWrite /private/etc/pw.* set nowritebackup

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'kshenoy/vim-signature'
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'othree/html5.vim'
Plugin 'ap/vim-css-color'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'dag/vim2hs'
Plugin 'tpope/vim-markdown'
Plugin 'juvenn/mustache.vim'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'zah/nimrod.vim'
Plugin 'mattn/emmet-vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'mattn/webapi-vim.git'
Plugin 'moll/vim-node'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sjl/gundo.vim'
Plugin 'shutnik/jshint2.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'shougo/neocomplete.vim'
Plugin 'mxw/vim-jsx'
Plugin 'reedes/vim-colors-pencil'
Plugin 'scrooloose/syntastic'

call vundle#end()

" syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

filetype plugin indent on

" pangloss/vim-javascript
:set regexpengine=1
:syntax enable

" easy motion
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

" layout colors
syntax enable
colorscheme pencil
set background=dark
let g:airline_theme='pencil'

" vim-airline
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#enabled = 1

" empty characters highlight
set laststatus=2
set list
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~"

" neocomplete
let g:neocomplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

set clipboard=unnamed

" es6 bind to js filetype
autocmd BufRead,BufNewFile *.es6,*.js setfiletype javascript

" nim filetype
autocmd BufRead,BufNewFile *.nim setfiletype nim
autocmd FileType nim set tabstop=4|set shiftwidth=4|set expandtab

" strings numbering
set relativenumber
set number

" my mappings
map <F7> :!reset<CR>

nmap <silent> ;z :sh<CR>
nmap <silent> ;. :Explore<CR>
nmap <silent> ;c :echo expand('%:p')<CR>
" TODO: jshing must hint only js files (if filetype javascript)
nmap <silent> ;h :JSHint<CR>

" tabs mappings
nmap <silent> ;W :tabclose<CR>
nmap <silent> ;T :tabnew<CR>

" clipboard mappings
vmap <silent> ;y :w !xsel -i<CR><CR>
nmap <silent> ;p :read !xsel<CR>

" buffers mappings
nmap <silent> ;w :bdelete<CR>
nmap <silent> ;t :enew<CR>
nmap <silent> ;v :vnew <CR>
nmap <silent> ;s :new<CR>
nmap <silent> ;n :bn<CR>
nmap <silent> ;b :bp<CR>

" gundo mappings
nmap <silent> ;g :GundoToggle<CR>
nmap <silent> ;r :GundoRenderGraph<CR>

vnoremap < <gv
vnoremap > >gv

if has('gui_running')
	set guioptions-=T
	set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
endif
