"setup vim-plug {{{

  "Note: install vim-plug if not present
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif

  "Note: Skip initialization for vim-tiny or vim-small.
  if !1 | finish | endif
  if has('vim_starting')
    set nocompatible               " Be iMproved
    " Required:
    call plug#begin()
  endif

"}}}

call plug#begin('~/.vim/plugged')

"
"
" Plugin Section
"
"
" Theme
"
Plug 'cormacrelf/vim-colors-github'
" Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
" cSpell:disable
" Plug 'tomasiser/vim-code-dark'
" File Explorer
Plug 'scrooloose/nerdtree' |
   \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-smartf', 'coc-snippets', 'coc-eslint', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-highlight', 'coc-sh', 'coc-spell-checker', 'coc-yaml', 'coc-actions']
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround' 
Plug 'tpope/vim-repeat'
Plug 'neomake/neomake'
Plug 'kassio/neoterm'
" Version control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Allow :Gbrowse to open in Github
Plug 'tpope/vim-rhubarb'
" Status bar
Plug 'vim-airline/vim-airline'
" Tab bar
" Plug 'pacha/vem-tabline'
" Icons
Plug 'ryanoasis/vim-devicons'
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
" Session management
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
" Tab rename
Plug 'gcmt/taboo.vim' 
" Undo History Browser
Plug 'mbbill/undotree'
" Copy/Yank history keeper
" Plug 'maxbrunsfeld/vim-yankstack'
" Window manager
Plug 'paroxayte/vwm.vim'
" Autosave
Plug '907th/vim-auto-save'
" Colorize hex
Plug 'chrisbra/Colorizer'
" Rainbow parens
Plug 'luochen1990/rainbow'
" Word coersion (e.g.) to snake_case
Plug 'tpope/vim-abolish'
" Visually show line indents
Plug 'Yggdroot/indentLine'
" Allow collapse/expand in yaml
Plug 'pedrohdz/vim-yaml-folds'
" Terraform format 
Plug 'hashivim/vim-terraform'
" Tab align plugin
Plug 'godlygeek/tabular'
" Movement with camelCase & snake_case words
Plug 'bkad/CamelCaseMotion'
" PlantUML Syntax
Plug 'aklt/plantuml-syntax'
" JSX highlighting and tab
Plug 'maxmellon/vim-jsx-pretty'
" cSpell:enable
" Coffeescript
Plug 'kchmck/vim-coffee-script'
" IDE-like search all
Plug 'dyng/ctrlsf.vim'
" Mustache support
Plug 'mustache/vim-mustache-handlebars'
" Styled components syntax highlighting 
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
" Prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
call plug#end()

"
"
"Config Section
"
"
" System-specifc configs
if has('unix')
  let s:uname = system("echo -n \"$(uname)\"")
  if !v:shell_error && s:uname == "Linux"
    " Assume Linux
    let g:clipboard = {
      \ 'name': 'xsel',
      \ 'copy': {
      \     '+': 'xsel -ib',
      \     '*': 'xsel -ip'
      \ },
      \ 'paste': {
      \     '+': 'xsel -ob',
      \     '*': 'xsel -op'
      \ },
      \ 'cache_enabled': 1
      \ }
  else
    " Assume Mac
    let g:clipboard = {
      \ 'name': 'pbcopypaste',
      \ 'copy': {
      \     '+': 'pbcopy',
      \     '*': 'pbcopy'
      \ },
      \ 'paste': {
      \     '+': 'pbpaste',
      \     '*': 'pbpaste'
      \ },
      \ 'cache_enabled': 1
      \ }
  endif
endif

" Use hybrid line numbers
set number 
" Highlight cursor line
set cursorline
set cursorcolumn
" Cursor color
autocmd InsertEnter * highlight Cursor ctermfg=White ctermBg=Black 
autocmd InsertLeave * highlight Cursor ctermfg=White ctermBg=Black
" Syntax highlighting
set encoding=utf-8
syntax enable
set hidden
set shiftwidth=2
set tabstop=2
set clipboard^=unnamed,unnamedplus
set expandtab
set laststatus=2
" Fold after 20 lines
set foldlevelstart=20
" open new split panes to right and below
set splitright
set splitbelow
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Hack to make undo only undo one word at a time
inoremap <Space> <Space><C-g>u
" Mouse
set mouse=n
" Smart case searching
set ignorecase
set smartcase
" Don't hide quotes and symbols
set conceallevel=0

"
" Custom keybindings
"
" Up and down with shift K/J
nnoremap <silent> K <C-u> 
nnoremap <silent> J <C-d> 
" Indent w < and >
nnoremap > :execute "normal! >>_"<CR>
nnoremap < :execute "normal! <<_"<CR>
vnoremap > >gv"
vnoremap < <gv"
xnoremap > >gv"
xnoremap < <gv"
" Reload nvim config in nvim config files
autocmd! FileType vim nnoremap <M-r> :so $MYVIMRC<CR> 
" Refresh buffer
nnoremap <M-r> :edit<CR>
" Close tab
nnoremap <leader>c :tabc<CR>
nnoremap <leader>o :tabo<CR>
" Save
nnoremap <C-s> :w<CR>
" Close all other buffers
nnoremap <C-q> :bufdo bd!<CR> 
" use alt+hjkl to move between split/vsplit panels
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap <C-h> <Esc><C-w>h
inoremap <C-j> <Esc><C-w>j
inoremap <C-k> <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l
" Vertical split with C-w v, horiztonal split with C-w z
nnoremap <C-w>z :split<CR>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
tnoremap <leader>1 1<C-h> <C-\><C-n>1gt
tnoremap <leader>2 2<C-h> <C-\><C-n>2gt
tnoremap <leader>3 3<C-h> <C-\><C-n>3gt
tnoremap <leader>4 4<C-h> <C-\><C-n>4gt
tnoremap <leader>5 5<C-h> <C-\><C-n>5gt
tnoremap <leader>6 6<C-h> <C-\><C-n>6gt
tnoremap <leader>7 7<C-h> <C-\><C-n>7gt
tnoremap <leader>8 8<C-h> <C-\><C-n>8gt
tnoremap <leader>9 9<C-h> <C-\><C-n>9gt
tnoremap <leader>0 <C-h> <C-\><C-n>:tablast<CR>

" Buffer navigation
" nnoremap <leader>1 :buffer 1<CR>
" nnoremap <leader>2 :buffer 2<CR>
" nnoremap <leader>3 :buffer 3<CR>
" nnoremap <leader>4 :buffer 4<CR>
" nnoremap <leader>5 :buffer 5<CR>
" nnoremap <leader>6 :buffer 6<CR>
" nnoremap <leader>7 :buffer 7<CR>
" nnoremap <leader>8 :buffer 8<CR>
" nnoremap <leader>9 :buffer 9<CR>

" Move lines up / down 
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Add newlines above/below w/o entering insert mode
nmap <M-o> o<Esc>k
nmap <M-O> O<Esc>j

" Open new buffer with entered file
nnoremap <Leader>b :e 
" Nav to prev/next buffer
" nnoremap ,k :bp<CR>
" nnoremap ,j :bn<CR>
" tnoremap ,k <C-\><C-n>:bp<CR>
" tnoremap ,j <C-\><C-n>:bn<CR>
" inoremap ,k <Esc>:bp<CR>
" inoremap ,j <Esc>:bn<CR>
" Close current buffer
" nnoremap ,c :bd<CR>
" Close all other open buffers
" nnoremap ,o :%bdelete<bar>edit #<bar>normal `"<CR>

" Reopen last closed window with <leader>u
augroup bufclosetrack
  au!
  autocmd WinLeave * let g:lastWinName = @%
augroup END
function! LastWindow()
  exe "split " . g:lastWinName
endfunction
command! -nargs=0 CallLastWindow call LastWindow()
nnoremap <leader>u :CallLastWindow<CR>

" Custom resize shortcuts
nnoremap <C-w><M-1> :resize 15<CR>
nnoremap <C-w><M-2> :resize 25<CR>
nnoremap <C-w><M-3> :resize 50<CR>
" Resize windows with arrow keys
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>

" Increment / decrement 
" Force decimal-based arithmetic
set nrformats=
nnoremap + <C-a>
nnoremap - <C-x>
" For visual sequence inc/dec
xnoremap + g<C-a>
xnoremap - g<C-x>

"
" Theme Opts
"
"

" Cycle through themes function
let g:total_themes = 2
let g:current_theme_num = g:total_themes 
set termguicolors
function! CycleTheme()
  if (g:current_theme_num >= g:total_themes)
    let g:current_theme_num = 0
  else
    let g:current_theme_num = g:current_theme_num + 1
  endif

  " Theme 0 is default theme
  if (g:current_theme_num == 0)
    " github theme
    colorscheme github
    let g:airline_theme='github'
    let g:github_colors_soft = 0
    set background=light
    " Tabline Colors for github theme
    hi TabLine ctermfg=grey ctermbg=236 cterm=NONE
    hi TabLineSel ctermfg=white  ctermbg=114  cterm=NONE cterm=bold
    " Change color of git diff
    hi DiffChange guibg=#CDFFD8 guifg=black
    hi DiffAdd gui=NONE guibg=#ACF2BD guifg=black
    hi DiffText guibg=#ACF2BD guifg=black
    hi DiffDelete guibg=#FDEEF0 guifg=#F8B8C0
    " Error message box color
    highlight CocErrorFloat ctermfg=black guifg=black
  elseif (g:current_theme_num == 1)
    " onedark theme
    colorscheme onedark
    let g:airline_theme='onedark'
    set background=dark
    " Tabline Colors for Onedark theme
    hi TabLine ctermfg=145 ctermbg=236 cterm=NONE
    hi TabLineSel ctermfg=black  ctermbg=114  cterm=NONE cterm=bold
    " Change color of git diff
    highlight DiffChange ctermfg=145 ctermbg=235
    highlight DiffText ctermfg=Black ctermbg=114
  endif
endfunction

nnoremap <leader>t :call CycleTheme()<CR> 
" Set default theme
call CycleTheme()

" Clear inactive buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
nnoremap <leader>db :call DeleteInactiveBufs()<CR>

" Rainbow parens plugin
let g:rainbow_active = 1

" Colorizer plugin (hex codes)
let g:colorizer_auto_color = 0

" Fugitive (git)
"
nnoremap <leader>gg :G<CR> <bar> <C-W>T 
nnoremap ,gg <Esc> <Bar> :G<CR> <Bar> :resize 15<CR>
" Select LHS change in conflict diff
nnoremap <leader>gl :diffget //3<CR>
" Select RHS change in conflict diff
nnoremap <leader>gr :diffget //2<CR>
" Revert change in diff view
nnoremap <leader>grr :diffput
" Custom func for git to accept both merge conflicts (remove all conflicts markers)
"Creates the command :GremoveConflictMarkers
function! RemoveConflictMarkers() range
  echom a:firstline.'-'.a:lastline
  execute a:firstline.','.a:lastline . ' g/^<\{7}\|^|\{7}\|^=\{7}\|^>\{7}/d'
endfunction
"-range=% default is whole file
command! -range=% GremoveConflictMarkers <line1>,<line2>call RemoveConflictMarkers()
nnoremap <leader>gb :GremoveConflictMarkers<CR>
xnoremap <leader>gb :'<,'>GremoveConflictMarkers<CR>
" Git diff on current file
nnoremap <leader>gd :Gdiff :0<CR>
nnoremap <leader>gdm :Gdiff main<CR>

"
" CamelCaseMotion config
"
" Set leader for camelCaseMotion to ,
let g:camelcasemotion_key = ','

"
" Vim-GitGutter
"
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

"
" Sessions
"
" Sessions are unique to branch
" let g:prosession_per_branch=1
let g:prosession_on_startup = 1
nnoremap <leader>s :echo prosession#ListSessions()<CR>
nnoremap <leader><C-s> :Prosession

"
" Autosave plugin config
"
let g:auto_save        = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["InsertLeave", "TextChanged", "FocusLost"]
" Set vim setting for autosave too
set autowriteall

"
" (DEPRECATED: for airline) Powerline
"
" let g:Powerline_symbols = 'fancy'
" let g:Powerline_theme = 'solarized256'
" let g:Powerline_colorscheme = 'solarized256'
" Insert the charcode segment after the filetype segment
" call Pl#Theme#ReplaceSegment('scrollpercent', 'fileinfo')

"
" Tabline config
"

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  if (exists("g:tablineclosebutton"))
    let s .= '%=%999XX'
  endif
  return s
endfunction
set tabline=%!Tabline()

"
" Nerdtree Config
"
" Don't load built-in browser, netrw
let loaded_netrwPlugin = 1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" Toggle to current file
nnoremap <silent> <leader><C-b> :NERDTreeFind<CR>
" Fix to allow OnTabEnter to work
let g:NERDTreeHijackNetrw = 0

"
" Terminal Config
"
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" Ctrl+w break for terminal
tmap <C-w> <Esc><C-w>
tmap <C-b> <Esc><C-b>
" Toggle terminal off
tmap <M-t> <Esc><C-w>c

" start terminal in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert
nnoremap <M-t> :split <bar> resize 15 <bar> term<CR>
" Open terminal at current dir
nnoremap <leader><M-t> :let $VIM_DIR=expand('%:p:h')<CR> <bar> :lcd $VIM_DIR<CR> <bar> :split<CR> <bar> :resize 15<CR> <bar> :term<CR> 
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.
let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1
function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window the right the current one
    wincmd J
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd J   
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif

  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")

  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

" With this maps you can now toggle the terminal
nnoremap <F7> :call MonkeyTerminalToggle()<cr>
tnoremap <F7> <C-\><C-n>:call MonkeyTerminalToggle()<cr>

" This an example on how specify command with different types of files.
" augroup go
    " autocmd!
    " autocmd BufRead,BufNewFile *.go set filetype=go
    " autocmd FileType go nnoremap <F5> :call MonkeyTerminalExec('go run ' . expand('%'))<cr>
" augroup END
    
"
" Search Config
"
" Open commands
nnoremap <C-p> :FZF<CR>
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>ff :Ag<CR>

command! -nargs=* AgQ call fzf#vim#ag(<q-args>, {'down': '40%', , 'options': '-q '.shellescape(<q-args>.' ')})
command! -bang -nargs=* FzfAg                              
  \ call fzf#vim#ag(<q-args>,
  \                 '--ignore "node_modules"',
  \                 '--ignore "content/*"',
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Prevent fzf bug when pressing esc in window
if has("nvim")
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  " au FileType fzf tunmap <buffer> <Esc>
endif

" ctrlsh search config
let g:ctrlsf_confirm_save = 0
nmap <leader>fa <Plug>CtrlSFPrompt
vmap <leader>fa <Plug>CtrlSFVwordPath

"
" NERDCommenter config
"

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Keybindings
let g:NERDCreateDefaultMappings = 0
" inoremap <leader>c <C-o>:call NERDComment(0,"toggle")<C-m>
vnoremap <leader>/ :call nerdcommenter#Comment(0, "toggle")<CR>
nnoremap <leader>/ :call nerdcommenter#Comment(0, "toggle")<CR>

"
" vim-terraform config
"
let g:terraform_align=0
let g:terraform_fmt_on_save=0

"
" coc.nvim (autocomplete/JS stuff) config
"
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-@> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()
" Use <leader>f to format
vmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm <Plug>(coc-format-selected)

" Use <cr> to confirm completion, `<C-g>u` 1means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nnoremap <M-e> <Plug>(coc-diagnostic-info)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> <M-d> :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" File rename
nmap <leader>rf :CocCommand workspace.renameCurrentFile<CR>

" Rename in regular or visual mode, lowercase for paragraph, upper for scope
" From: https://www.reddit.com/r/vim/comments/1zvks1/best_way_to_rename_variable_in_several_spots_in_a/cfxfwb0?utm_source=share&utm_medium=web2x&context=3
nnoremap <leader>rr :'{,'}s/\<<C-r>=expand('<cword>')<CR>\>/
nnoremap <leader>RR :%s/\<<C-r>=expand('<cword>')<CR>\>/

xnoremap <leader>rr :<C-u>'{,'}s/<C-r>=GetVisualSelection()<CR>/
xnoremap <leader>RR :<C-u>%s/<C-r>=GetVisualSelection()<CR>/

function! GetVisualSelection()
    let old_reg = @v
    normal! gv"vy
    let raw_search = @v
    let @v = old_reg
    return substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current selection.
vmap <leader>af  <Plug>(coc-fix-current)
" Apply AutoFormat on file
nmap <leader>af <Esc>:call CocAction('runCommand', 'eslint.executeAutofix')<CR>

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}%{ObsessionStatus()}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"
" Undotree config
"
nnoremap <F5> :UndotreeToggle<cr>
if has("persistent_undo")
  set undodir=$MY_CONFIG_DIR/vim_undo_history
  set undofile
endif

"
" indentLine config 
"
let g:indentLine_char = '⦙'


"
" Scripts
"
" Used for executing macro on lines that match pattern
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Mapping to search visually selected text with * or #
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>

"
" Filetype configs
"
filetype plugin on
autocmd FileType javascript setlocal shiftwidth=2
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Show quotes in json
autocmd Filetype json
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0
" Auotformat tf file with <leader>fm
autocmd Filetype terraform nmap <leader>fm :TerraformFmt<CR>
" Autoformat .json file with <leader>fm 
autocmd Filetype json nmap <leader>fm :%!jq<CR>
