set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim

set encoding=UTF-8
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
set tabstop=4          " a tab is four spaces
set softtabstop=4      " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab          " expand tabs by default (overloadable per file type later)
set shiftwidth=4       " number of spaces to use for autoindenting
set shiftround         " use multiple of shiftwidth when indenting with '<' and '>'
set autoindent         " always set autoindenting on
set number             " always show line numbers
set showmatch          " set show matching parenthesis
set ignorecase         " ignore case when searching
set smartcase          " ignore case if search pattern is all lowercase,

set smarttab           " insert tabs on the start of a line according to

set scrolloff=4        " keep 4 lines off the edges of the screen when scrolling

call plug#begin('~/.vim/plugged')
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'anott03/nvim-lspinstall'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'zivyangll/git-blame.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'm-demare/hlargs.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'wakatime/vim-wakatime'
Plug 'shougo/neocomplete.vim'
Plug 'junegunn/vim-easy-align'
Plug 'morhetz/gruvbox'
Plug 'shougo/neco-vim'
Plug 'sheerun/vim-polyglot'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'ycm-core/YouCompleteMe'
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/AutoComplPop'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'Raimondi/delimitMate'
Plug 'christoomey/vim-system-copy'
Plug 'vim-airline/vim-airline'

call plug#end()

let g:system_copy#copy_command='xclip -sel clipboard'
let g:system_copy_silent = 1
let g:system_copy#paste_command='xclip -sel clipboard -o'
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP


"syscopy
syntax enable
filetype plugin indent on

autocmd BufNewFile,BufRead *.rs set filetype=rust


let g:ale_linters = {
\  'rust': ['analyzer'],
\}

let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }

" Optional, configure as-you-type completions
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>

colorscheme gruvbox
set background=dark
     
