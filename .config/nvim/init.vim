filetype off

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()


" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

" let Vundle manage Vundle, required

" syntax highlighting
Plugin 'mxw/vim-jsx'
Plugin 'leafgarland/typescript-vim'
Plugin 'pangloss/vim-javascript'

" buffer TABline
Plugin 'ap/vim-buftabline'

" svelte;
Plugin 'evanleck/vim-svelte'

" Coc :O
" Plugin 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plugin 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
Plugin 'carlitux/deoplete-ternjs'

Plugin 'scrooloose/nerdtree'

Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
" git diff 
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/emmet-vim'
Plugin 'prettier/vim-prettier'
" language pack ? 
Plugin 'sheerun/vim-polyglot'
Plugin 'trevordmiller/nova-vim' 
Plugin 'adolenc/cl-neovim' 
" lisp parentheses
Plugin 'amdt/vim-niji'
Plugin 'jgdavey/tslime.vim'
" Racket lang
Plugin 'wlangstroth/vim-racket'
Plugin 'ctrlpvim/ctrlp.vim'

" Run commands asynchronously :AsyncRun
Plugin 'skywind3000/asyncrun.vim'

" FZF serach
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'


" ACK search
Plugin 'mileszs/ack.vim'

" linting
" Plugin 'w0rp/ale'

" snippets :
Plugin 'SirVer/ultisnips'

" colors very colorful 

Plugin 'chrisbra/Colorizer'

" Plugin emoji

Plugin 'junegunn/vim-emoji'

" All of your Plugins must be added before the following line
call vundle#end()
" filetype plugin indent on  " allows auto-indenting depending on file type
filetype indent on  " allows auto-indenting depending on file type


set relativenumber
set ignorecase

set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab 


""""" NERD TREE """""""""""""""""""""""""""""

map <C-n> :NERDTreeToggle<CR>
map <C-o> :NERDTreeToggle %<CR>
map <leader>r :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeWinSize=50

""""" ALE linting """""""""""""""""""""""""""

" let g:ale_linters = {'javascript': ['eslint']}
set completeopt+=noinsert

" let g:ale_javascript_tsserver_config_path = './jsconfig.json'
" let g:ale_completion_enabled = 0
" let g:ale_fix_on_save = 1
" 
" let g:jsx_ext_required = 0 " Allow JSX in normal JS files
" let g:ale_statusline_format = ['error', 'warning %d', '']
" "g:syntastic_javascript_checkers = ['eslint']
" let g:ale_linters_explicit = 1
" let g:ale_linters = {
"       \  'javascript': [ 'tsserver'] ,
"       \  'css': ['stylelint'],
"       \  'scss': ['stylelint'],
"       \}
" 
" let g:ale_fixers = {
" \   'javascript': [
" \       'stylelint', 'eslint'
" \   ]
" \}
" 
" let g:ale_sign_error = '⚠️' "Less aggressive than the default '>>'
" let g:ale_sign_warning = '💡'
" "let g:ale_echo_msg_warning_str = 'Warning 📣'
" "let g:ale_echo_msg_error_str = '❧ Error'
" let g:ale_lint_on_enter = 1 " Less distracting when opening a new file
" let g:ale_lint_on_text_changed = 'normal'


""""""""""""""""""""""""""""""""""""""    COC tsserver and stuff

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()


" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)



" autocmd BufWritePost *.js PrettierAsync
"autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %
autocmd BufWritePost *.css AsyncRun -post=checktime stylelint --fix %
autocmd BufWritePost *.scss AsyncRun -post=checktime stylelint --fix %


"xxxxxxxxxxxxxxxxx PASTED xxxxxxxxxxxxxxxxx

" let g:airline#extensions#ale#enabled = 1
" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_fixers = {'javascript': ['prettier'], 'scss': ['stylelint'], 'python': ['yapf', 'isort']}
" let g:ale_set_highlights = 1
" let g:ale_set_signs = 1
" let g:ale_sign_column_always = 1

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"
"
" ACK settings
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

let g:ackprg = 'ag --vimgrep'


" Prettier 
" let g:prettier#exec_cmd_async = 1
" run prettier on every specified file on save
let g:prettier#autoformat = 0
" autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

colorscheme nova

vnoremap . :normal . <CR>
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y


" Those are SICP vim settings """"""""""""""""""""""""""""""
let g:niji_dark_colours = [
    \ [ '81', '#5fd7ff'],
    \ [ '99', '#875fff'],
    \ [ '1',  '#dc322f'],
    \ [ '76', '#5fd700'],
    \ [ '3',  '#b58900'],
    \ [ '2',  '#859900'],
    \ [ '6',  '#2aa198'],
    \ [ '4',  '#268bd2'],
    \ ]

let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" statusline
set noshowmode
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filename': 'LightLineFilename'
      \ },
      \ }

function! LightLineFilename()
  return expand('%>%f')
endfunction

function! LightlineModified()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
        
function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''                                                                                                                 
endfunction                                                                                                                                                                      

" function! LightlineFilename()
"   return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
"     \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
"     \  &ft == 'unite' ? unite#get_status_string() :
"     \  &ft == 'vimshell' ? vimshell#get_status_string() :
"     \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
"     \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
" endfunction                                                                                                                                                                      

function! LightlineFugitive()
  if &ft !~? 'vimfiler' && exists('*fugitive#head')
    return fugitive#head()
  endif
    return ''
endfunction
        

" Linter stuff
"
" Linter stuff
"
" Ignore stuff while searching:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=**/node_modules/**
set wildignore+=*/build/*

let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = '\v[\/](node_modules)|\v[\/](coverage)'
let g:ctrlp_custom_ignore = '\v[\/](coverage)'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|node_modules|coverage',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }	


" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})

let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

" vim-javacript concealing : 

" set conceallevel=1
" 
" let g:javascript_conceal_function             = "ƒ"
" let g:javascript_conceal_null                 = "ø"
" let g:javascript_conceal_this                 = "@"
" let g:javascript_conceal_return               = "⇚"
" let g:javascript_conceal_undefined            = "¿"
" let g:javascript_conceal_NaN                  = "ℕ"
" let g:javascript_conceal_prototype            = "¶"
" let g:javascript_conceal_static               = "•"
" let g:javascript_conceal_super                = "Ω"
" let g:javascript_conceal_arrow_function       = "⇒"
" let g:javascript_conceal_noarg_arrow_function = "🞅"
" let g:javascript_conceal_underscore_arrow_function = "🞅"
"
" gutentags
"

" emoji autocomplete


let g:ctrlp_map = '<c-]>'
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>


" this fixes problem with nerdtree when deleting buffer
nnoremap \d :bp<cr>:bd #<cr>
" autocmd VimEnter * ALEDetail 


autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

filetype plugin on
syntax on


