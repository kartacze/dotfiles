

filetype indent on  " allows auto-indenting depending on file type

set relativenumber
set ignorecase

set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab 


set foldmethod=indent
set foldlevel=3

vnoremap . :normal . <CR>
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y

"""""""""""""""""""" COLOR SCHEME """"""""""""""""""""


if (has("termguicolors"))
 set termguicolors
endif

" Theme
syntax enable
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
let g:gruvbox_contrast_dark = 'hard'

set background=dark


"""""""""""""""""""" FZF """"""""""""""""""""

let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

let g:ackprg = 'ag --vimgrep'
nnoremap <C-]> :Files <CR>


" statusline
set noshowmode
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


"""""""""""""""""""" LIGHTLINE """"""""""""""""""""

let g:lightline = {
      \ 'colorscheme': 'oceanicnext',
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

function! LightlineFugitive()
  if &ft !~? 'vimfiler' && exists('*fugitive#head')
    return fugitive#head()
  endif
    return ''
endfunction


"""""""""""""""""""" NERD TREE """"""""""""""""""""

map <C-o> :NERDTreeToggle %<CR>
map <leader>r :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeWinSize=50

let g:NERDTreeMinimalUI=1
let g:NERDTreeWinPos='rightbelow'
let g:NERDTreeIgnore=['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
let g:NERDTreeStatusline=''
" Automaticaly close nvim if NERDTree is only thing left open
 autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set guifont=Fura\ Code:h12

" " vim-devicons
 let g:webdevicons_enable = 1
 let g:webdevicons_enable_nerdtree = 1
 let g:webdevicons_enable_unite = 1
 let g:webdevicons_enable_vimfiler = 1
 let g:webdevicons_enable_airline_tabline = 1
 let g:webdevicons_enable_airline_statusline = 1
 let g:webdevicons_enable_ctrlp = 1
 let g:webdevicons_enable_flagship_statusline = 1
 let g:WebDevIconsUnicodeDecorateFileNodes = 1
 let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
 let g:webdevicons_conceal_nerdtree_brackets = 1
 let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
 let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
 let g:webdevicons_enable_denite = 1
 let g:WebDevIconsUnicodeDecorateFolderNodes = 1
 let g:DevIconsEnableFoldersOpenClose = 1
 let g:DevIconsEnableFolderPatternMatching = 1
 let g:DevIconsEnableFolderExtensionPatternMatching = 1
 let WebDevIconsUnicodeDecorateFolderNodesExactMatches = 1


" not sure if this is for nerdtree

nnoremap \d :bp<cr>:bd #<cr>

"""""""""""""""""""" BUFTABLINE """"""""""""""""""""

set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>




autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
au! BufNewFile,BufRead *.svelte set ft=html

"""""""""""""""""""" CLOSETAG """"""""""""""""""""

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,typescript,typescript.tsx,tsx'

let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" tslime {{{
let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<localleader>t'
let g:tslime_visual_mapping = '<localleader>t'
let g:tslime_vars_mapping = '<localleader>T'
" }}}

"""""""""""""""""""" SYNTAX """"""""""""""""""""

filetype plugin on
syntax on

