" plugins are handled with vim-plug
" for first run you need to install vim-plug manualy
" please refer https://github.com/junegunn/vim-plug

filetype off

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

"""""""""""""""""""" COC """""""""""""""""""" 

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}

"""""""""""""""""""" UTILITES """""""""""""""""""" 

Plug 'itchyny/lightline.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-buftabline'
Plug 'alvan/vim-closetag'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'

" FZF serach
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" ACK search
Plug 'mileszs/ack.vim'

"""""""""""""""""""" SYNTAX """"""""""""""""""""
" Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
" Plug 'pangloss/vim-javascript'

"""""""""""""""""""" COLOR SCHEMES """"""""""""""""""""

Plug 'rafi/awesome-vim-colorschemes'

"""""""""""""""""""" RACKET """"""""""""""""""""
Plug 'wlangstroth/vim-racket'
Plug 'sjl/tslime.vim'

" Initialize plugin system
call plug#end()
