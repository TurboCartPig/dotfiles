" My broken shitty vimrc file
"
" List of binaries it needs (incomplete) (I should check for these)
" (health-check?)
" rustup, rls, cargo, rustc
" npm, yarn
" clang, clangd, clang-format, clang-tidy
" gdb, lldb or something
" fzf, rg (ripgrep)

" Polyglot settings
" ------------------------------------------------------------------------------------------------------------
let g:polyglot_disabled = ['rust', 'haskell', 'latex']

" To uninstall unneeded plugins; run:
" call dein#recache_runtimepath()
" call map(dein#check_clean(), "delete(v:val, 'rf')")

" Handle Platform specifics
if has('win32')
	let dein_install_path = 'C:\Users\dennis\Appdata\Local\dein'
	let dein_plugin_path = 'C:\Users\dennis\Appdata\Local\dein\repos\github.com\Shougo\dein.vim'

	set runtimepath+=C:\Users\dennis\Appdata\Local\dein\repos\github.com\Shougo\dein.vim
elseif has('unix')
	let dein_install_path = '~/.cache/dein'
	let dein_plugin_path = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

	set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
endif

if dein#load_state(dein_install_path)
	call dein#begin(dein_install_path)
	call dein#add(dein_plugin_path)

	" Utils
	call dein#add('junegunn/fzf.vim')
	call dein#add('junegunn/fzf')
	call dein#add('honza/vim-snippets')
	call dein#add('scrooloose/nerdtree')
	call dein#add('jistr/vim-nerdtree-tabs')
	call dein#add('mhinz/vim-startify')
	call dein#add('vimwiki/vimwiki')

	" This isn't default?
	call dein#add('tpope/vim-sensible')
	call dein#add('tpope/vim-fugitive')
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-commentary')
	call dein#add('tpope/vim-endwise')
	call dein#add('tpope/vim-repeat')
	call dein#add('tpope/vim-projectionist')
	call dein#add('kana/vim-operator-user')
	call dein#add('airblade/vim-rooter')

	" Motion
	call dein#add('justinmk/vim-sneak')
	call dein#add('wellle/targets.vim')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('christoomey/vim-tmux-navigator')

	" Lang support
	call dein#add('sheerun/vim-polyglot')
	call dein#add('neovimhaskell/haskell-vim') " I might not need thees
	call dein#add('rust-lang/rust.vim')        " ^
	call dein#add('lervag/vimtex')
	call dein#add('mattn/emmet-vim')

	" Auto do stuff
	call dein#add('sbdchd/neoformat')
	call dein#add('turbio/bracey.vim', {
				\ 'build': 'yarn install --prefix server'
				\ })

	" Completion framework
	call dein#add('neoclide/coc.nvim', {
				\ 'merged': 0,
				\ 'rev': 'release',
				\ })

	" Themes
	call dein#add('morhetz/gruvbox')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ryanoasis/vim-devicons')

	call dein#end()
	call dein#save_state()
endif

" My own settings
" ------------------------------------------------------------------------------------------------------------
" Required by something
scriptencoding utf-8
set encoding=utf-8
set hidden
filetype plugin indent on

" Disable backups and swapfiles. Thats what a VCS are for.
set nobackup
set nowritebackup
set noswapfile

" Search
set incsearch

" Formatting
set ignorecase
set smartcase
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0

" Formatting overrides
augroup FormattingOverrides
	autocmd FileType html,haskell,cabal set expandtab
	autocmd FileType html,haskell,cabal set shiftwidth=2
augroup END

" Visual stuff
set number
set numberwidth=3
set cursorline
set termguicolors
set cmdheight=2

" Sane splits
set splitright
set splitbelow

" Perf stuff
set updatetime=16

" Misc
set wildmenu
set showmatch
set nocp
set so=2
set mouse=a
" set ssop="blank, buffers, curdir, tabpages, slash, unix, winpos, winsize"
" set ssop="tabpages"
set completeopt="menu,preview,noselect,noinsert"
set shortmess+=c
set signcolumn=yes
set clipboard+=unnamedplus

" Spelling correction
" set spell
" set spelllang=en_US

" Leader
let mapleader = ' '

" Termdebug settings
" ------------------------------------------------------------------------------------------------------------
let g:termdebug_popup = 0
let g:termdebug_wide  = 163

" Neoformat settings
" ------------------------------------------------------------------------------------------------------------
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim  = 1
let g:neoformat_enabled_haskell    = ['ormolu']

" Format on save
augroup fmt
	autocmd!
	" Merge neoformat changes with previous changes
	" autocmd BufWritePre * undojoin | Neoformat

	" Keed neoformat as separate undo block
	autocmd BufWritePre * Neoformat
augroup END

" My own keybinds
" ------------------------------------------------------------------------------------------------------------

nnoremap <silent><Leader><Leader> :b#<CR>

nnoremap <silent><Tab> :NERDTreeTabsToggle<CR>

" Move around easier in insert mode
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>

" Strong H/L
nnoremap H 0
nnoremap L $
vnoremap H 0
vnoremap L $

" Move between windows in normal mode
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Fzf settings
" ------------------------------------------------------------------------------------------------------------
nnoremap <silent><c-p> :Files<CR>
nnoremap <silent><Leader>r :Rg<CR>
nnoremap <silent><Leader>f :Files<CR>
nnoremap <silent><Leader>g :GFiles<CR>
nnoremap <silent><Leader>b :Buffers<CR>

" Coc.nvim settings
" ------------------------------------------------------------------------------------------------------------
let g:coc_global_extensions = [
			\ 'coc-git',
			\ 'coc-lists',
			\ 'coc-marketplace',
			\ 'coc-highlight',
			\ 'coc-json',
			\ 'coc-yaml',
			\ 'coc-toml',
			\ 'coc-tabnine',
			\ 'coc-clangd',
			\ 'coc-cmake',
			\ 'coc-rls',
			\ 'coc-python',
			\ 'coc-vimlsp',
			\ 'coc-html',
			\ 'coc-css',
			\ 'coc-emmet',
			\ 'coc-rome'
			\ ]

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Show documentation in preview window
noremap <silent>gk :call <SID>show_documentation()<CR>

" Rename word under cursor
nnoremap <leader>rn <Plug>(coc-rename)

" Goto's
nnoremap <silent>gd <Plug>(coc-definition)
nnoremap <silent>gy <Plug>(coc-type-definition)
nnoremap <silent>gi <Plug>(coc-implementation)
nnoremap <silent>gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)

nnoremap <silent><A-y> :CocList --normal yank<CR>

nmap <silent>gs :CocList symbols<CR>

nnoremap <silent><C-.> :CocList actions<CR>

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Coc-git settings
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

nnoremap <silent><Leader>gs :CocCommand git.chunkStage<CR>
nnoremap <silent><Leader>gu :CocCommand git.chunkUndo<CR>

" VimWiki
" ------------------------------------------------------------------------------------------------------------
let g:vimwiki_list = [{
			\ 'path': '~/.vimwiki/',
			\ 'syntax': 'markdown',
			\ 'ext': '.md'
			\ }]

" vimtex
" ------------------------------------------------------------------------------------------------------------
let g:tex_flavor = 'latex'

" Emmet.vim
" ------------------------------------------------------------------------------------------------------------
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Comfortable-motion
" ------------------------------------------------------------------------------------------------------------
let g:comfortable_motion_no_default_mappings = 1
let g:comfortable_motion_interval = 1000.0 / 60.0
let g:comfortable_motion_friction = 110.0
let g:comfortable_motion_air_drag = 5.0

noremap <silent><ScrollWheelUp> :call comfortable_motion#flick(-50)<CR>
noremap <silent><ScrollWheelDown> :call comfortable_motion#flick(50)<CR>

nnoremap <silent>J :call comfortable_motion#flick(50)<CR>
nnoremap <silent>K :call comfortable_motion#flick(-50)<CR>
vnoremap <silent>J :call comfortable_motion#flick(50)<CR>
vnoremap <silent>K :call comfortable_motion#flick(-50)<CR>

" Vim-sneak
" ------------------------------------------------------------------------------------------------------------
" let g:sneak#label = 1
map , <Plug>Sneak_;
map ; <Plug>Sneak_,

" Hardcopy to pdf
" ------------------------------------------------------------------------------------------------------------
set printoptions=syntax:y,number:y,left:0,right:2,top:2,bottom:2
command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"

" Startify
" ------------------------------------------------------------------------------------------------------------
let s:neovim_asci = [
			\ '         _             _            _      _          _        _         _   _       ',
			\ '        /\ \     _    /\ \         /\ \   /\ \    _ / /\      /\ \      /\_\/\_\ _   ',
			\ '       /  \ \   /\_\ /  \ \       /  \ \  \ \ \  /_/ / /      \ \ \    / / / / //\_\ ',
			\ '      / /\ \ \_/ / // /\ \ \     / /\ \ \  \ \ \ \___\/       /\ \_\  /\ \/ \ \/ / / ',
			\ '     / / /\ \___/ // / /\ \_\   / / /\ \ \ / / /  \ \ \      / /\/_/ /  \____\__/ /  ',
			\ '    / / /  \/____// /_/_ \/_/  / / /  \ \_\\ \ \   \_\ \    / / /   / /\/________/   ',
			\ '   / / /    / / // /____/\    / / /   / / / \ \ \  / / /   / / /   / / /\/_// / /    ',
			\ '  / / /    / / // /\____\/   / / /   / / /   \ \ \/ / /   / / /   / / /    / / /     ',
			\ ' / / /    / / // / /______  / / /___/ / /     \ \ \/ /___/ / /__ / / /    / / /      ',
			\ '/ / /    / / // / /_______\/ / /____\/ /       \ \  //\__\/_/___\\/_/    / / /       ',
			\ '\/_/     \/_/ \/__________/\/_________/         \_\/ \/_________/        \/_/        ',
			\ '                                                                                     ',
			\ ]

let g:startify_custom_header = map(s:neovim_asci, '"   ".v:val')

let g:startify_lists = [
			\ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
			\ { 'type': 'files', 'header': ['   Files'] },
			\ { 'type': 'sessions', 'header': ['   Sessions'] },
			\ ]

let g:startify_bookmarks = [ '~/.config/nvim/init.vim', '~/.zshrc' ]

" Airline settings
" ------------------------------------------------------------------------------------------------------------
let g:airline_theme = 'minimalist'

let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts     = 1
let g:airline_highlighting_cache  = 1


let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#coc#enabled        = 1
let g:airline#extensions#tabline#enabled    = 1
let g:airline#extensions#tabline#formatter  = 'unique_tail'

" Theme and colorscheme
" ------------------------------------------------------------------------------------------------------------
set background=dark
set guifont=SauceCodePro\ NF:h16
colorscheme gruvbox

highlight link SignColumn GruvboxBg0
highlight link CocGitAddedSign GruvboxBg2
highlight link CocGitChangeRemovedSign GruvboxBg2
highlight link CocGitChangedSign GruvboxBg2
highlight link CocGitRemovedSign GruvboxBg2
highlight link CocGitTopRemovedSign GruvboxBg2

