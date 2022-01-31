set nocompatible
set visualbell
set backspace=indent,eol,start
syntax on
filetype on
filetype plugin on
filetype indent on
 
filetype plugin indent on



set hlsearch
set incsearch          " ...dynamically as they are typed.
set showmode           " always show what mode we're currently editing in
set nowrap             " don't wrap lines
set tabstop=2          " a tab is four spaces
set softtabstop=2      " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab          " expand tabs by default (overloadable per file type later)
set shiftwidth=2       " number of spaces to use for autoindenting
set shiftround         " use multiple of shiftwidth when indenting with '<' and '>'
set autoindent         " always set autoindenting on
set number             " always show line numbers
set showmatch          " set show matching parenthesis
set ignorecase         " ignore case when searching
set smartcase          " ignore case if search pattern is all lowercase,
                       " case-sensitive otherwise
set smarttab           " insert tabs on the start of a line according to

set scrolloff=4        " keep 4 lines off the edges of the screen when scrolling

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'ycm-core/YouCompleteMe'
" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/AutoComplPop'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'

call plug#end()

syntax enable
filetype plugin indent on

autocmd BufNewFile,BufRead *.rs set filetype=rust

call plug#begin()
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
call plug#end()

let g:ale_linters = {
\  'rust': ['analyzer'],
\}

let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }

" Optional, configure as-you-type completions
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>






