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
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle "pangloss/vim-javascript"
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'mkitt/tabline.vim'
"Plugin 'Lokaltog/vim-powerline'
Plugin 'itchyny/lightline.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/html5.vim'
Plugin 'nono/jquery.vim'
Plugin 'tyru/open-browser.vim'
Plugin 'buftabs'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'ap/vim-css-color'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'shougo/vimproc'
Plugin 'Shougo/vimshell.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dag/vim2hs'

call vundle#end()
filetype plugin indent on

execute pathogen#infect()

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

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

:noremap <C-left> :bprev<CR>
:noremap <C-right> :bnext<CR>

"syntax enable
"hi Normal ctermfg=16 ctermbg=254
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
"let g:solarized_termcolors=256
"let g:solarized_termtrans = 1
syntax enable
colorscheme lucius
set background=dark

hi TabLine      ctermfg=Black  ctermbg=241 cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=235 cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=30 cterm=NONE


autocmd vimenter * NERDTree

set mouse=a

vnoremap < <gv
vnoremap > >gv

set clipboard=unnamed

let g:neocomplcache_enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
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

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
