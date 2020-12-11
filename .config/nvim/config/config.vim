filetype indent on  " allows auto-indenting depending on file type

set number
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

let g:python3_host_prog = 'python3.8'


" if (has("termguicolors"))
" endif

" Theme
syntax enable

set termguicolors
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox


" set background=dark


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

" lightline
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \ }
\ }


function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

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


nnoremap <silent> <Leader>e :<C-U>:Defx -resume -buffer_name=explorer -split=vertical -vertical_preview<CR>
nnoremap <C-o> :Defx<CR>
" nnoremap <leader>r :Defx `expand('%:p:h')` -search=`expand('%:p')` -buffer-name=defx<CR>
nnoremap <leader>r :Defx -search=`expand('%:p')` -buffer-name=defx<CR>
nnoremap <silent> - :<C-U>:Defx `expand('%:p:h')` -search=`expand('%:p')` -buffer-name=defx<CR>


autocmd FileType defx call s:defx_my_settings()
" autocmd BufWritePost * call defx#redraw()

function! s:defx_my_settings() abort
  " Define mappings
  setl norelativenumber 
  setl nonumber 
  nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> l defx#do_action('open')
  nnoremap <silent><buffer><expr> E defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d defx#do_action('remove')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction


call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ })

call defx#custom#option('_', {
      \ 'winwidth': 45,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'defxplorer',
      \ 'toggle': 1,
      \ 'columns': 'indent:icon:icons:filename:git',
      \ 'resume': 1,
      \ 'profile': 1,
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

call defx#custom#column('git', 'column_length', 2)

call defx#custom#column('git', {
	\   'indicators': {
	\     'Modified'  : '🔥',
	\     'Staged'    : '➕',
	\     'Untracked' : '🚚',
	\     'Renamed'   : '📯',
	\     'Unmerged'  : '≠',
	\     'Ignored'   : 'ⁱ',
	\     'Deleted'   : '✖',
	\     'Unknown'   : '❓'
	\   }
	\ })

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

