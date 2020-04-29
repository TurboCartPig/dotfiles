vim.cmd('packadd nvim-lsp')
local lsp = require'nvim_lsp'
lsp.clangd.setup{}
lsp.ghcide.setup{}
lsp.jsonls.setup{}
lsp.pyls_ms.setup{}
lsp.rls.setup{}
lsp.vimls.setup{}
