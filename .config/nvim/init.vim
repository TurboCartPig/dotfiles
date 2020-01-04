" My broken shitty vimrc file
"
" List of binaries it needs (incomplete) (I should check for these)
" (health-check?)
" rustup, rls, cargo, rustc
" npm, yarn
" clang, clangd, clang-format, clang-tidy
" gdb, lldb or something
" fzf, rg (ripgrep)

" To uninstall unneeded plugins; run:
" call dein#recache_runtimepath()
" call map(dein#check_clean(), "delete(v:val, 'rf')")

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
	call dein#begin('~/.cache/dein')
	call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

	" Stuff
	call dein#add('Shougo/vimproc.vim', { 'build': 'make' })
	call dein#add('junegunn/fzf.vim')
	call dein#add('editorconfig/editorconfig-vim')
	call dein#add('rhysd/vim-clang-format')

	" This isn't default?
	call dein#add('tpope/vim-sensible')
	call dein#add('tpope/vim-fugitive')
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-commentary')
	call dein#add('tpope/vim-endwise')
	call dein#add('kana/vim-operator-user')
	call dein#add('rstacruz/vim-closer')
	call dein#add('FooSoft/vim-argwrap')
	call dein#add('airblade/vim-rooter')

	" Motion
	call dein#add('justinmk/vim-sneak')
	call dein#add('wellle/targets.vim')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('christoomey/vim-tmux-navigator')

	" Utils
	call dein#add('scrooloose/nerdtree')
	call dein#add('jistr/vim-nerdtree-tabs')
	call dein#add('mhinz/vim-startify')

	" Completion framework
	call dein#add('neoclide/coc.nvim', {
				\ 'rev': 'release',
				\ 'bulid': 'call coc#util#install()'
				\ })

	" Themes
	call dein#add('sheerun/vim-polyglot')
	call dein#add('morhetz/gruvbox')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ryanoasis/vim-devicons')
	call dein#add('junegunn/limelight.vim')
	call dein#add('junegunn/goyo.vim')
	" call dein#add('edkolev/tmuxline.vim')
	" call dein#add('edkolev/promptline.vim')

	call dein#end()
	call dein#save_state()
endif

" My own settings
" --------------------------------------------------------------------------------------------------------------------------------------------------------
" Required by something
scriptencoding utf-8
set encoding=utf-8
set hidden

" Disable backups
set nobackup
set nowritebackup

" Search
set incsearch
set hlsearch

" Formatting
set ignorecase
set smartcase
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=-1

" Visual stuff
set number
set relativenumber
set numberwidth=3
set cursorline
set termguicolors
set cmdheight=2

" Sane splits
set splitright
set splitbelow

" Perf stuff
set updatetime=16
set ttyfast
set lazyredraw

" Misc
set wildmenu
set showmatch
set nocp
set so=2
set mouse=a
" set ssop="blank, buffers, curdir, tabpages, slash, unix, winpos, winsize"
" set ssop="tabpages"
" set completeopt-=preview
set shortmess+=c
" set signcolumn=yes
set clipboard+=unnamedplus

" Spelling correction
" set spell
" set spelllang=en_us

" Leader
let mapleader = ' '

" Theme and colorscheme
" --------------------------------------------------------------------------------------------------------------------------------------------------------
set background=dark
colorscheme gruvbox

" Make the beckground transparent
au ColorScheme * hi Normal ctermbg=none guibg=none
au ColorScheme * hi NonText ctermbg=none guibg=none

" Airline settings
" --------------------------------------------------------------------------------------------------------------------------------------------------------
let g:airline_theme = 'base16_colors'
" let g:airline_solarized_bg = 'dark'

let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
" let g:airline_left_sep = '>'
" let g:airline_right_sep = '<'
" let g:airline_left_sep = ''

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:airline#extensions#coc#enabled = 1

" Startify
" --------------------------------------------------------------------------------------------------------------------------------------------------------
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

" Coc.nvim settings
" --------------------------------------------------------------------------------------------------------------------------------------------------------
let g:coc_global_extensions = [
			\ 'coc-rls', 'coc-lists', 'coc-git',
			\ 'coc-tabnine', 'coc-marketplace',
			\ 'coc-json', 'coc-yaml', 'coc-highlight'
			\ ]

"  Use TAB to auto-complete
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use K to show documentation in preview window
noremap <silent>gk :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Gotos
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)

nnoremap <silent><C-y> :CocList --normal yank<CR>

nmap <silent>gs :CocList symbols<CR>

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" ArgWarp
" --------------------------------------------------------------------------------------------------------------------------------------------------------
let g:argwrap_padded_braces = '{'

nnoremap <silent><leader>a :ArgWrap<CR>

" Remove trailing spaces
" --------------------------------------------------------------------------------------------------------------------------------------------------------
" function TrimWhiteSpace()
" 	%s/\s*$//
" 	''
" endfunction

" set list listchars=trail:.,extends:>
" autocmd FileWritePre * call TrimWhiteSpace()
" autocmd FileAppendPre * call TrimWhiteSpace()
" autocmd FilterWritePre * call TrimWhiteSpace()
" autocmd BufWritePre * call TrimWhiteSpace()

" Clang options
" --------------------------------------------------------------------------------------------------------------------------------------------------------
autocmd FileType c,cpp,objc map <buffer> = <Plug>(operator-clang-format)

" Goyo and limelight
" --------------------------------------------------------------------------------------------------------------------------------------------------------
let g:goyo_width = "80%"
let g:goyo_height = "90%"

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

" Hardcopy to pdf
" --------------------------------------------------------------------------------------------------------------------------------------------------------
set printoptions=syntax:y,number:y,left:0,right:2,top:2,bottom:2
command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"

" Comfortable-motion
" --------------------------------------------------------------------------------------------------------------------------------------------------------
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
" --------------------------------------------------------------------------------------------------------------------------------------------------------
" let g:sneak#label = 1
map , <Plug>Sneak_;
map ; <Plug>Sneak_,

" Fzf
" --------------------------------------------------------------------------------------------------------------------------------------------------------
nnoremap <silent><Leader>b :Buffers<CR>
nnoremap <silent><Leader>f :Files<CR>

" My own keybinds
" --------------------------------------------------------------------------------------------------------------------------------------------------------

nnoremap <silent><Leader>rg :Rg<CR>

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

