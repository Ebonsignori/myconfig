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
Plug 'joshdick/onedark.vim'
" cSpell:disable
" Plug 'tomasiser/vim-code-dark'
" File Explorer
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-smartf', 'coc-snippets', 'coc-pairs', 'coc-eslint', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-highlight', 'coc-sh', 'coc-spell-checker', 'coc-yaml']
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
Plug 'maxbrunsfeld/vim-yankstack'
" Window manager
Plug 'paroxayte/vwm.vim'
" Autosave
Plug '907th/vim-auto-save'
" Colorize hex
Plug 'chrisbra/Colorizer'
" Rainbow parens
Plug 'luochen1990/rainbow'
" cSpell:enable
call plug#end()

"
"
"Config Section
"
"
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
" Quit
nnoremap <C-q> :q<CR> 
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
nnoremap ,k :bp<CR>
nnoremap ,j :bn<CR>
tnoremap ,k <C-\><C-n>:bp<CR>
tnoremap ,j <C-\><C-n>:bn<CR>
" inoremap ,k <Esc>:bp<CR>
" inoremap ,j <Esc>:bn<CR>
" Close current buffer
nnoremap ,c :bd<CR>
" Close all other open buffers
nnoremap ,o :%bdelete<bar>edit #<bar>normal `"<CR>

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
" codedark.vim
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" let g:airline_theme = 'codedark'
" set t_Co=256
" set t_ut=
" colorscheme codedark
" g:onedark_termcolors=256
colorscheme onedark
let g:airline_theme='onedark'

function! s:echo1() abort
  echo 'Hello world'
endfunction

function! EchoDelay1() abort
  call timer_start(1000, function('s:echo1'))
endfunction

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
" Change color of git diff
highlight DiffChange ctermfg=145 ctermbg=235
highlight DiffText ctermfg=Black ctermbg=114
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
" Yankstack
"
nnoremap <leader>p :Yanks<CR>

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
" Uncomment to test theme colors
" let theme_colors = onedark#GetColors()
" let test_var = theme_colors.black.cterm
" echo "color: " . test_var
" Colors: 114 = green, 236 = light grey, 145 = light white, 235 = term bg / black
hi TabLine ctermfg=145 ctermbg=236 cterm=NONE
" hi TabLineFill  ctermfg=lightgrey  ctermbg=darkgrey cterm=NONE
hi TabLineSel ctermfg=Black  ctermbg=114  cterm=NONE cterm=bold

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
" neovim-remote config
"
" We use nvr to open nvim inside an nvim terminal. e.g. git commit msg 
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
endif

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
" Fix to allow OnTabEnter to work
let g:NERDTreeHijackNetrw = 0

"
" Terminal Config
"
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert
nnoremap <leader><M-t> :terminal<CR>
nnoremap <M-t> :split <bar> resize 15 <bar> term<CR>


"
" Search Config
"
nnoremap <C-p> :FZF<CR>
nnoremap ,b :Buffers<CR>
nnoremap ,f :Ag<CR>
" Toggle when open with same open command(s)
autocmd! FileType fzf tnoremap <buffer> <C-p> <c-c>
autocmd! FileType fzf tnoremap <buffer> ,b <c-c>
autocmd! FileType fzf tnoremap <buffer> ,f <c-c>
autocmd! FileType fzf nnoremap <buffer> <C-p> <C-w>c
autocmd! FileType fzf nnoremap <buffer> ,b <C-w>c
autocmd! FileType fzf nnoremap ,f <C-w>c

command! -nargs=* AgQ call fzf#vim#ag(<q-args>, {'down': '40%', 'options': '-q '.shellescape(<q-args>.' ')})
command! -bang -nargs=* FzfAg                              
  \ call fzf#vim#ag(<q-args>,
  \                 '--ignore "node_modules"',  <--- any options here
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
:
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
  au FileType fzf tunmap <buffer> <Esc>
endif

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
vnoremap <leader>/ :call NERDComment(0,"toggle")<CR>
nnoremap <leader>/ :call NERDComment(0,"toggle")<CR>


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
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

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
autocmd FileType javascript setlocal shiftwidth=2 stop=2
