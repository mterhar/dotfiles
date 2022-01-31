" use extended feature of vim (no compatible with vi)
set nocompatible
" specify encoding
set encoding=utf-8
" specify file encoding
set fileencodings=utf-8,iso-2022-jp,sjis,euc-jp
" specify file formats
set fileformats=unix,dos
" take backup
" if not, specify [ set nobackup ]
set backup
" specify backup directory
set backupdir=~/.vim_backup
" number of search histories
set history=50
" ignore Case
set ignorecase
" distinct Capital if you mix it in search words
set smartcase
" highlights matched words
" if not, specify [ set nohlsearch ]
set hlsearch
" use incremental search
" if not, specify [ set noincsearch ]
set incsearch
" show line number
" if not, specify [ set nonumber ]
set number
" Visualize some whitespaces
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
set list
" highlights parentheses
set showmatch
" enable auto indent
" if not, specify [ noautoindent ]
set autoindent
" show color display
" if not, specify [ syntax off ]
syntax on
" change colors for comments if it's set [ syntax on ]
highlight Comment ctermfg=LightCyan
" wrap lines 
" if not, specify [ set nowrap ]
set wrap

set scrolloff=10       " set number of screen lines to keep above/below the cursor
set colorcolumn=80
highlight ColorColumn ctermbg=236 guibg=lightgrey
highlight LineNr ctermfg=239 guibg=lightgrey
set rtp+=~/.fzf
