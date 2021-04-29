" My broken shitty vimrc file

" TODO: List all the programs that the config depends on, like rls or ripgrep
" TODO: Define checkhealth stuff to check that everything works

" Custom functions and commands {{{

" Delete and uninstall plugins not installed below
function CleanPluggins()
	call dein#recache_runtimepath()
	call map(dein#check_clean(), "delete(v:val, 'rf')")
endfunction

command! DeinClean call CleanPluggins()

" Hardcopy to pdf
set printoptions=syntax:y,number:y,left:0,right:2,top:2,bottom:2
command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"

 " }}}

" Polyglot settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:polyglot_disabled = ['go', 'rust']

" }}}

" Handle platform specifics for plugins {{{
if has('win32')
	let dein_install_path = 'C:\Users\dennis\Appdata\Local\dein'
	let dein_plugin_path = 'C:\Users\dennis\Appdata\Local\dein\repos\github.com\Shougo\dein.vim'

	set runtimepath+=C:\Users\dennis\Appdata\Local\dein\repos\github.com\Shougo\dein.vim
elseif has('unix')
	let dein_install_path = '~/.cache/dein'
	let dein_plugin_path = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

	set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
endif

" }}}

" Define plugins {{{
if dein#load_state(dein_install_path)
	call dein#begin(dein_install_path)
	call dein#add(dein_plugin_path)

	" Utils
	call dein#add('scrooloose/nerdtree')
	call dein#add('jistr/vim-nerdtree-tabs')
	call dein#add('mhinz/vim-startify')
	call dein#add('sbdchd/neoformat')
	call dein#add('editorconfig/editorconfig-vim')
	call dein#add('f-person/git-blame.nvim')
	call dein#add('lewis6991/gitsigns.nvim')

	" This isn't default?
	call dein#add('tpope/vim-sensible')
	call dein#add('tpope/vim-fugitive')
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-commentary')
	call dein#add('tpope/vim-endwise')
	call dein#add('tpope/vim-repeat')
	call dein#add('kana/vim-operator-user')
	call dein#add('airblade/vim-rooter')

	" Motion
	call dein#add('wellle/targets.vim')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('christoomey/vim-tmux-navigator')

	" Lang support
	call dein#add('sheerun/vim-polyglot')
	call dein#add('fatih/vim-go', { 'merged': v:false })
	call dein#add('rust-lang/rust.vim', { 'merged': v:false })

	" LSP and completions
	call dein#add('neovim/nvim-lspconfig')
	call dein#add('hrsh7th/nvim-compe')
	" call dein#add('tzachar/compe-tabnine', { 'hook_post_update': '!./install.sh' })
	call dein#add('nvim-lua/popup.nvim')
	call dein#add('nvim-lua/plenary.nvim')
	call dein#add('nvim-telescope/telescope.nvim')
	call dein#add('nvim-lua/lsp_extensions.nvim')
	call dein#add('nvim-lua/lsp-status.nvim')
	call dein#add('kosayoda/nvim-lightbulb')
	call dein#add('nvim-treesitter/nvim-treesitter', { 'hook_post_update': ':TSUpdate' })
	call dein#add('nvim-treesitter/nvim-treesitter-refactor')
	" NOTE: This is buggy for some reason
	" call dein#add('romgrk/nvim-treesitter-context')

	" Themes
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ryanoasis/vim-devicons')
	call dein#add('rktjmp/lush.nvim')
	call dein#add('npxbr/gruvbox.nvim')

	call dein#end()
	call dein#save_state()
endif

" }}}

" Set options {{{
" ------------------------------------------------------------------------------------------------------------
set hidden
filetype plugin indent on

" Disable backups and swapfiles. Thats what a VCS' are for.
set nobackup
set nowritebackup
set noswapfile

" Search
set incsearch
set showmatch

" Formatting
set ignorecase
set smartcase
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0

" Visual stuff
set number
set numberwidth=3
set signcolumn=yes
set cursorline
set cmdheight=2
set scrolloff=5
set termguicolors

" Folds
set foldlevelstart=99

" Sane splits
set splitright
set splitbelow

" Menus
set wildmenu
set completeopt=menuone,noselect,noinsert
set shortmess=filoOTcF

" Misc
set mouse=a
set clipboard+=unnamedplus
set updatetime=200

" Leader
let mapleader = ' '

" }}}

" Abbreviations {{{
" ------------------------------------------------------------------------------------------------------------
" Command abbreviations
cnoreabbrev Q q
cnoreabbrev Q! q!
cnoreabbrev Qa qa
cnoreabbrev W w
cnoreabbrev W! w!
cnoreabbrev Wa wa
cnoreabbrev WA wa
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev WQ! wq!

" Abbreviations
noreabbrev lenght length
noreabbrev widht width
noreabbrev higth height
noreabbrev nigthly nightly

" }}}

" Per language options {{{
" ------------------------------------------------------------------------------------------------------------
" Formatting overrides
augroup FormattingOverrides
	autocmd!
	autocmd FileType haskell,cabal setlocal
		\ expandtab
		\ shiftwidth=2
augroup END

" Override fold methods per language
augroup FoldingSettings
	autocmd!

	" Use treesitter to automatically create folds
	autocmd FileType c,cpp,go,rust,lua setlocal
		\ foldmethod=expr
		\ foldexpr=nvim_treesitter#foldexpr()

	" Use manually placed markers in all vimscript files
	autocmd FileType vi,vim setlocal
		\ foldlevel=0
		\ foldmethod=marker
augroup END

" Spell checking
augroup SpellChecking
	autocmd!
	autocmd FileType markdown,text,rst setlocal
		\ spell
		\ spelllang=en_us
augroup END

" }}}

" Neovide (GUI) settings {{{
" See: https://github.com/Kethku/neovide/wiki/Configuration
" ------------------------------------------------------------------------------------------------------------
" Fixes broken AltGr keybinds
inoremap <C-M-[> [
inoremap <C-M-]> ]
inoremap <C-M-{> {
inoremap <C-M-}> }
inoremap <C-M-@> @
inoremap <C-M-`> `
inoremap <C-M-´> ´

" FIXME: Neovide draws fonts smaller than they should be.
set guifont=FiraCode\ NF:h15

let g:neovide_refresh_rate = 165

" }}}

" Termdebug settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:termdebug_popup = 0
let g:termdebug_wide  = 163

" }}}

" My own keybinds {{{
" ------------------------------------------------------------------------------------------------------------
nnoremap <silent><Leader><Leader> :b#<CR>

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

" }}}

" Hightlights and colorschemes {{{
" ------------------------------------------------------------------------------------------------------------

" Clear annoying colors
augroup ColorSchemeOverrides
	autocmd!
	autocmd ColorScheme *       highlight SignColumn        guibg=none
	autocmd ColorScheme *       highlight Folded            guibg=none
	autocmd ColorScheme *       highlight FoldColumn        guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxAquaSign   guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxBlueSign   guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxGreenSign  guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxOrangeSign guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxPurpleSign guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxRedSign    guibg=none
	autocmd ColorScheme gruvbox highlight GruvboxYellowSign guibg=none
augroup END

" Set theme
set background=dark
lua vim.cmd([[colorscheme gruvbox]])

" }}}

" LSP settings {{{
" ------------------------------------------------------------------------------------------------------------

" NOTE: Some mappings come from plugins or lua.
" - gd is mapped to goto definition with ts or fallback to ls

" TODO: Use "themes" for telescope, probably easier if it's done all in lua

nnoremap <silent>gr      <cmd>lua require'telescope.builtin'.lsp_references()<CR>
nnoremap <silent>gs      <cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>
nnoremap <silent>gll     <cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<CR>
nnoremap <silent><M-CR>  <cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>
nnoremap <silent><C-CR>  <cmd>lua require'telescope.builtin'.spell_suggest()<CR>
nnoremap <silent><C-p>   <cmd>lua require'telescope.builtin'.git_files()<CR>
nnoremap <silent><C-t>   <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent>R       <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent><C-q>   <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
" nnoremap <silent>gll     <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

" Compe autocompleteions mappings
" inoremap <silent><expr><C-Space> compe#complete()
inoremap <silent><expr><C-y>     compe#confirm("<CR>")
inoremap <silent><expr><C-e>     compe#close("<C-e>")

" Enable completions for supported languages
augroup neovim_lsp
	autocmd!

	" Enable type inlay hints (Only for rust)
	autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
		\ lua require'lsp_extensions'.inlay_hints{ prefix = '» ', highlight = "Comment" }
augroup END

" Create a status line part from lsp status
function! LspStatus() abort
	let status = luaeval('require("lsp-status").status()')
	return trim(status)
endfunction

" }}}

" git-blame.nvim settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:gitblame_enabled          = v:false
let g:gitblame_message_template = '<author> • <summary> • <date>'

" }}}

" vim-go {{{
" ------------------------------------------------------------------------------------------------------------
" Disable functionality included by neovim itself
let g:go_code_completion_enabled = v:false
let g:go_gopls_enabled           = v:false

" Auto-stuff
let g:go_fmt_autosave            = v:true
let g:go_imports_autosave        = v:false
let g:go_mod_fmt_autosave        = v:true
let g:go_metalinter_autosave     = v:false

" Misc
let g:go_doc_keywordprg_enabled  = v:false
let g:go_def_mapping_enabled	 = v:false
let g:go_auto_type_info			 = v:false
let g:go_auto_sameids			 = v:false
let g:go_jump_to_error			 = v:true
let g:go_metalinter_command      = 'golangci-lint'
let g:go_metalinter_deadline     = "2s"

" }}}

" Comfortable-motion {{{
" ------------------------------------------------------------------------------------------------------------
let g:comfortable_motion_no_default_mappings = 1
let g:comfortable_motion_interval            = 1000.0 / 60.0
let g:comfortable_motion_friction            = 110.0
let g:comfortable_motion_air_drag            = 5.0

noremap  <silent><ScrollWheelUp>   <cmd>call comfortable_motion#flick(-50)<CR>
noremap  <silent><ScrollWheelDown> <cmd>call comfortable_motion#flick(50)<CR>

nnoremap <silent>J                 <cmd>call comfortable_motion#flick(50)<CR>
nnoremap <silent>K                 <cmd>call comfortable_motion#flick(-50)<CR>
vnoremap <silent>J                 <cmd>call comfortable_motion#flick(50)<CR>
vnoremap <silent>K                 <cmd>call comfortable_motion#flick(-50)<CR>

" }}}

" Neoformat settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:neoformat_basic_format_align = v:false
let g:neoformat_basic_format_retab = v:true
let g:neoformat_basic_format_trim  = v:true
let g:neoformat_enabled_python     = ['black', 'autopep8']
let g:neoformat_enabled_haskell    = ['stylishhaskell', 'ormolu']

nnoremap <silent><C-M-L> <cmd>Neoformat<CR>

" }}}

" Startify {{{
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
			\ ]

let g:startify_bookmarks = [ '~/.config/nvim/init.vim',  '~/.config/nvim/lua/init.lua', '~/.config/zsh/.zshrc' ]

" }}}

" Airline settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:airline_theme = 'minimalist'

" General
let g:airline_skip_empty_sections = v:true
let g:airline_powerline_fonts     = v:true
let g:airline_highlighting_cache  = v:true

" Extensions
let g:airline_extensions                   = [ 'branch', 'quickfix', 'tabline', 'term', 'wordcount' ]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#default#layout    = [
			\ [ 'a', 'b', 'c' ],
			\ [ 'warning', 'error', 'z' ]
			\ ]

" Define lsp status part
call airline#parts#define_function('lsp_status', 'LspStatus')
call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
let g:airline_section_warning = airline#section#create_right(['lsp_status'])

" }}}

" Source the lua init file {{{
" ------------------------------------------------------------------------------------------------------------
" This both sources the init.lua file, and imports the module
lua init = require("init")

" }}}
