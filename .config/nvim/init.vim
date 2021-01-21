" My broken shitty vimrc file

" TODO: List all the programs that the config depends on, like rls or ripgrep
" TODO: Define checkhealth stuff to check that everything works

" Delete and uninstall plugins not installed below
function CleanPluggins()
	call dein#recache_runtimepath()
	call map(dein#check_clean(), "delete(v:val, 'rf')")
endfunction

command! DeinClean call CleanPluggins()

" Polyglot settings
" ------------------------------------------------------------------------------------------------------------
let g:polyglot_disabled = ['latex']

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
	call dein#add('kana/vim-operator-user')
	call dein#add('airblade/vim-rooter')

	" Motion
	call dein#add('wellle/targets.vim')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('christoomey/vim-tmux-navigator')

	" Lang support
	call dein#add('sheerun/vim-polyglot')
	call dein#add('lervag/vimtex')
	call dein#add('mattn/emmet-vim')
	call dein#add('sbdchd/neoformat')
	call dein#add('RishabhRD/popfix')
	call dein#add('RishabhRD/nvim-lsputils')
	call dein#add('neovim/nvim-lspconfig')
	call dein#add('nvim-lua/completion-nvim')
	call dein#add('nvim-lua/lsp_extensions.nvim')
	call dein#add('nvim-lua/lsp-status.nvim')
	call dein#add('aca/completion-tabnine', { 'build': './install.sh' })
	call dein#add('nvim-treesitter/nvim-treesitter', {
		\ 'hook_post_update': ':TSUpdate'
		\ })

	" Themes
	" call dein#add('morhetz/gruvbox')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ryanoasis/vim-devicons')
	call dein#add('tjdevries/colorbuddy.vim')
	call dein#add('npxbr/gruvbox.nvim')

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
	autocmd FileType haskell,cabal setlocal expandtab
	autocmd FileType haskell,cabal setlocal shiftwidth=2
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

" Misc
set wildmenu
set showmatch
set nocp
set so=2
set mouse=a
set completeopt=menu,noselect,noinsert
set shortmess+=c
set signcolumn=yes
set clipboard+=unnamedplus
set updatetime=200

" Leader
let mapleader = ' '

" Abbreviatoins
ab lenght length

" Termdebug settings
" ------------------------------------------------------------------------------------------------------------
packadd termdebug
let g:termdebug_popup = 0
let g:termdebug_wide  = 163

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

" Treesitter settings
" ------------------------------------------------------------------------------------------------------------
lua <<EOF
local configs = require'nvim-treesitter.configs'

configs.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}
EOF

set background=dark
lua require('colorbuddy').colorscheme('gruvbox')

" LSP settings
" ------------------------------------------------------------------------------------------------------------
lua <<EOF
local lspc = require'lspconfig'

lspc.rust_analyzer.setup {}
lspc.clangd.setup {}
lspc.gopls.setup {}
lspc.hls.setup {}
lspc.pyls.setup {}
lspc.vimls.setup {}

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

vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
EOF

nnoremap <silent> gd     <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-t>  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gI     <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-s>  <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr     <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0     <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW     <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gD     <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <M-CR> <cmd>lua vim.lsp.buf.code_action()<CR>

" Enable completions for supported languages
autocmd Filetype rust,go,c,cpp,python,haskell,cabal,lua,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd BufWritePre *.rs,*.go,*.c,*.cpp,*.py,*.hs,*.cabal,*.lua lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufEnter * lua require'completion'.on_attach()

" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
\ lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "Comment" }

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

" Neoformat settings
" ------------------------------------------------------------------------------------------------------------
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim  = 1
let g:neoformat_enabled_haskell    = ['ormolu']

nnoremap <silent><c-M-L> <cmd>Neoformat<CR>

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
let g:airline#extensions#tabline#enabled    = 1
let g:airline#extensions#tabline#formatter  = 'unique_tail'

