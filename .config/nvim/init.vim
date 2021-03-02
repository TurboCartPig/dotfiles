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

 " }}}

" Polyglot settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:polyglot_disabled = ['latex', 'go', 'rust']

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
	call dein#add('vimwiki/vimwiki')
	" call dein#add('andweeb/presence.nvim')

	" This isn't default?
	call dein#add('tpope/vim-sensible')
	call dein#add('tpope/vim-fugitive')
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-commentary')
	" call dein#add('tpope/vim-endwise')
	call dein#add('tpope/vim-repeat')
	call dein#add('kana/vim-operator-user')
	call dein#add('airblade/vim-rooter')
	call dein#add('cohama/lexima.vim')

	" Motion
	call dein#add('wellle/targets.vim')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('christoomey/vim-tmux-navigator')

	" Lang support
	call dein#add('sheerun/vim-polyglot')
	call dein#add('lervag/vimtex', { 'lazy': v:true, 'on_ft': ['latex', 'tex'] })
	call dein#add('mattn/emmet-vim', { 'lazy': v:true, 'on_ft': ['html', 'css'] })
	call dein#add('fatih/vim-go', { 'lazy': v:true, 'merged': v:false })
	call dein#add('rust-lang/rust.vim', { 'merged': v:false })

	" LSP and completions
	call dein#add('neovim/nvim-lspconfig')
	call dein#add('nvim-lua/popup.nvim')
	call dein#add('nvim-lua/plenary.nvim')
	call dein#add('nvim-telescope/telescope.nvim')
	call dein#add('kosayoda/nvim-lightbulb')
	call dein#add('glepnir/lspsaga.nvim')
	call dein#add('nvim-lua/lsp_extensions.nvim')
	call dein#add('nvim-lua/completion-nvim')
	" FIXME: This plugin is a bit shit atm
	" call dein#add('aca/completion-tabnine', { 'build': './install.sh' })
	call dein#add('nvim-treesitter/completion-treesitter')
	call dein#add('nvim-treesitter/nvim-treesitter', {
		\ 'hook_post_update': ':TSUpdate'
		\ })

	" Themes
	" call dein#add('morhetz/gruvbox')
	" call dein#add('mhinz/vim-signify')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ryanoasis/vim-devicons')
	call dein#add('rktjmp/lush.nvim')
	call dein#add('npxbr/gruvbox.nvim')
	" call dein#add('tjdevries/colorbuddy.vim')
	" call dein#add('tjdevries/gruvbuddy.nvim')

	call dein#end()
	call dein#save_state()
endif

" }}}

" My own settings {{{
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

" Sane splits
set splitright
set splitbelow

" Menu's
set wildmenu
set completeopt=menu,noselect,noinsert
set shortmess=filoOTcF

" Misc
set mouse=a
set clipboard+=unnamedplus
set updatetime=1000

" Leader
let mapleader = ' '

" }}}

" Abbreviations {{{

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

" }}}

" Per language options {{{
" Formatting overrides
augroup FormattingOverrides
	autocmd!
	autocmd FileType haskell,cabal setlocal expandtab shiftwidth=2
augroup END

augroup FoldingSettings
	autocmd!
	autocmd FileType c,cpp,rust setlocal foldmethod=syntax
	autocmd FileType vim setlocal foldmethod=marker
augroup END

" Spell checking
augroup SpellChecking
	autocmd!
	autocmd FileType md,text,rst, setlocal spell spelllang=en_us
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

let g:neovide_refresh_rate=165

" }}}

" Termdebug settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:termdebug_popup = 0
let g:termdebug_wide  = 163

" }}}

" My own keybinds {{{
" ------------------------------------------------------------------------------------------------------------
nnoremap <silent><Leader><Leader> :b#<CR>

" nnoremap <silent><Tab> :NERDTreeTabsToggle<CR>

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

" Treesitter settings {{{
" ------------------------------------------------------------------------------------------------------------
lua <<EOF
local configs = require'nvim-treesitter.configs'

configs.setup {
	ensure_installed = { "bash", "c", "cpp", "css", "go", "haskell", "html", "javascript", "json", "lua", "python", "rust", "toml", "yaml" },
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}
EOF

" }}}

set background=dark
lua vim.cmd([[colorscheme gruvbox]])
" lua require('colorbuddy').colorscheme('gruvbox')

" LSP settings {{{
" ------------------------------------------------------------------------------------------------------------
lua <<EOF
local lspc = require'lspconfig'

lspc.rust_analyzer.setup {}
lspc.clangd.setup {}
lspc.hls.setup {}
lspc.pyls.setup {}
lspc.vimls.setup {}
lspc.gopls.setup {}

-- Setup lua language server
local sumneko_root = vim.fn.expand("$HOME/Projects/lua-language-server")
local sumneko_bin  = sumneko_root .. "/bin/Linux/lua-language-server"
lspc.sumneko_lua.setup {
	cmd = { sumneko_bin, "-E", sumneko_root .. "/main.lua"};
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
		},
		diagnostics = { globals = { 'vim' }, },
		workspace = {
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.expand("VIMRUNTIME/lua/vim/lsp")] = true,
			},
		},
	},
}

local saga = require'lspsaga'
saga.init_lsp_saga()
EOF

nnoremap <silent> gd      <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" nnoremap <silent> gD      <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent> <M-CR>  <cmd>lua require'lspsaga.codeaction'.code_action()<CR>
nnoremap <silent> <C-s>   <cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>
nnoremap <silent> R       <cmd>lua require'lspsaga.rename'.rename()<CR>
nnoremap <silent> gD      <cmd>lua require'telescope.builtin'.lsp_references()<CR>
nnoremap <silent> gs      <cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>
" nnoremap <silent> <M-CR>  <cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>
nnoremap <silent> <C-p>   <cmd>lua require'telescope.builtin'.git_files()<CR>
nnoremap <silent> <C-t>   <cmd>lua vim.lsp.buf.hover()<CR>

let g:completion_confirm_key = "\<C-y>"
let g:completion_enable_auto_paren = v:true
let g:completion_auto_change_source = v:true
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_hover = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_chain_complete_list = {
	\ 'default': {
	\     'default': [
	\         { 'complete_items': ['lsp', 'tabnine', 'ts'] },
	\         { 'complete_items': ['path'], 'trigger_only': ['/'] },
	\         { 'mode': '<c-p>' },
	\         { 'mode': '<c-n>' }
	\     ],
	\     'comment': [
	\         { 'complete_items': ['tabnine', 'ts'] },
	\         { 'mode': '<c-p>' },
	\         { 'mode': '<c-n>' }
	\     ],
	\     'string': [
	\         { 'complete_items': ['tabnine', 'ts'] },
	\         { 'mode': '<c-p>' },
	\         { 'mode': '<c-n>' }
	\     ]
	\ }
\ }

" Enable completions for supported languages
augroup neovim_lsp
	autocmd!

	autocmd BufEnter * lua require'completion'.on_attach()

	autocmd FileType rust,go,c,cpp,python,haskell,cabal,lua,vim
		\ setlocal omnifunc=v:lua.vim.lsp.omnifunc

	autocmd BufWritePre *.rs,*.go,*.c,*.cpp,*.py,*.hs,*.cabal,*.lua
		\ lua vim.lsp.buf.formatting_sync(nil, 1000)

	" Show diagnostic popup on cursor hover
	autocmd CursorHold *.rs,*.go,*.c,*.cpp,*.py,*.hs,*.cabal,*.lua
		\ lua require'lspsaga.diagnostic'.show_line_diagnostics()

	" Show signature help on hover
	autocmd CursorHoldI *.rs,*.go,*.c,*.cpp,*.py,*.hs,*.cabal,*.lua
		\ lua require'lspsaga.signaturehelp'.signature_help()

	" Enable type inlay hints (Only for rust)
	autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
		\ lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "Comment" }

	" Show a lightbulb in the gutter if a codeaction is available
	autocmd CursorHold,CursorHoldI *.rs,*.go,*.c,*.cpp,*.py,*.hs,*.cabal,*.lua
		\ lua require'nvim-lightbulb'.update_lightbulb()
augroup END

" }}}

" Discord presence {{{
" ------------------------------------------------------------------------------------------------------------

" lua <<EOF
" local presence = require("presence")

" presence.setup{
"	auto_update       = true,
"	neovim_image_text = "Better than whatever you are using",
"	main_image        = "neovim",
" }
" EOF

" }}}

" VimWiki {{{
" ------------------------------------------------------------------------------------------------------------
let g:vimwiki_list = [{
			\ 'path': '~/.vimwiki/',
			\ 'syntax': 'markdown',
			\ 'ext': '.md'
			\ }]

" }}}

" vimtex {{{
" ------------------------------------------------------------------------------------------------------------
let g:tex_flavor = 'latex'

" }}}

" Emmet.vim {{{
" ------------------------------------------------------------------------------------------------------------
let g:user_emmet_install_global = 0

augroup EmmetFileType
	autocmd FileType html,css EmmetInstall
augroup END

" }}}

" vim-go {{{
" ------------------------------------------------------------------------------------------------------------
" Disable functionality included by neovim itself
let g:go_code_completion_enabled = v:false
let g:go_gopls_enabled           = v:false

" Autoformatting
let g:go_fmt_autosave        = v:true
let g:go_imports_autosave    = v:false
let g:go_mod_fmt_autosave    = v:true

" Misc
let g:go_def_mapping_enabled = v:false
let g:go_auto_type_info      = v:false
let g:go_auto_sameids        = v:false
let g:go_jump_to_error       = v:true

" }}}

" Comfortable-motion {{{
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

" }}}

" Neoformat settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim  = 1
let g:neoformat_enabled_python     = ['black']
let g:neoformat_enabled_haskell    = ['ormolu']

nnoremap <silent><c-M-L> <cmd>Neoformat<CR>

" }}}

" Hardcopy to pdf {{{
" ------------------------------------------------------------------------------------------------------------
set printoptions=syntax:y,number:y,left:0,right:2,top:2,bottom:2
command! Pdf hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo "Printing to PDF"

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
			\ { 'type': 'sessions', 'header': ['   Sessions'] },
			\ ]

let g:startify_bookmarks = [ '~/.config/nvim/init.vim', '~/.zshrc' ]

" }}}

" Airline settings {{{
" ------------------------------------------------------------------------------------------------------------
let g:airline_theme = 'minimalist'

let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts     = 1
let g:airline_highlighting_cache  = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled    = 1
let g:airline#extensions#tabline#formatter  = 'unique_tail'

" }}}
