set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Install L9 and avoid a Naming conflict if you've already installed a
" " different version somewhere else.
" " Plugin 'ascenator/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
" filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line


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
Plug 'shougo/neocomplete.vim'
Plug 'junegunn/vim-easy-align'
Plug 'morhetz/gruvbox'
Plug 'shougo/neco-vim'
Plug 'sheerun/vim-polyglot'
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
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'Raimondi/delimitMate'
Plug 'christoomey/vim-system-copy'
Plug 'vim-airline/vim-airline'


Plug 'prabirshrestha/vim-lsp' " vim-lsp
" or
" Plug 'autozimu/LanguageClient-neovim' " LanguageClient-neovim
" " or
" Plug 'neoclide/coc.nvim' " coc.nvim
" " or
" Plug 'neovim/nvim-lsp' " nvim-lsp

Plug 'jackguo380/vim-lsp-cxx-highlight'

call plug#end()

"syscopy
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



let g:lsp_cxx_hl_use_text_props = 1

colorscheme gruvbox
set background=dark
     
