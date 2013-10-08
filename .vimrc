" Pathogen
call pathogen#infect()
call pathogen#helptags()
 
set nocompatible
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
filetype plugin indent on
 
syntax on
set number
set hlsearch
set autoindent
set history=1000
set cursorline
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Nerdtree
autocmd vimenter * NERDTree
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
 

" ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
 

set background=dark
colorscheme solarized
