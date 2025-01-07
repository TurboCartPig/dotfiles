-- Servers I don't want to use for something specific
local sucky_servers = { "jsonls", "html", "pyright", "gopls" }

-- Format the buffer using either LSP or some fallback
local function format()
    vim.lsp.buf.formatting_seq_sync({}, 1000, {})
end

-- Rename symbol under cursor, either with LSP or Treesitter
local function rename()
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.supports_method "textDocument/rename" and not vim.tbl_contains(sucky_servers, client.name) then
            vim.lsp.buf.rename()
            return
        end
    end

    -- TODO: Check if treesitter supports rename
    require("nvim-treesitter-refactor.smart_rename").smart_rename(0)
end

-- Run this every time a language server attaches to a buffer
local function on_attach(client, bufnr)
    -- Auto-clearing autocmd group. Unique for this client and buffer
    local augroup = vim.api.nvim_create_augroup("LspAttach" .. bufnr, { clear = true })

    -- Setup completion
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Setup lightbulb on code_action
    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "DiagnosticsSignInfo" })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = function()
            require("nvim-lightbulb").update_lightbulb()
        end,
        group = augroup,
    })

    -- Setup line diagnostic on hover
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        buffer = bufnr,
        callback = function()
            vim.diagnostic.open_float(nil,
                vim.tbl_extend("error", { focusable = false, border = "rounded " }, { scope = "cursor" }))
        end,
        group = augroup,
    })

    -- Disable formatting with sucky servers
    if vim.tbl_contains(sucky_servers, client.name) then
        client.server_capabilities.document_formatting = false        -- For <=0.7
        client.server_capabilities.documentFormattingProvider = false -- For >=0.8
    end

    -- TODO : Rewrite with client.supports_method() api
    -- Setup lsp-hover on hold
    -- if client.resolved_capabilities.hover then
    -- 	vim.cmd "autocmd CursorHold <buffer> lua vim.lsp.buf.hover()"
    -- end

    -- Setup signature help on hold
    -- FIXME: STFU when there is no signature help available
    -- if client.resolved_capabilities.signature_help then
    -- 	vim.cmd "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()"
    -- end
end

-- Setup lsp_signature -------------------------------------------------------------- {{{1

local function setup_lsp_signature()
    local lsp_signature = require "lsp_signature"

    lsp_signature.setup {
        floating_window = false,
        hint_enable = true,
        hint_prefix = "",
    }
end

-- Setup null-ls -------------------------------------------------------------------- {{{1

local function setup_null()
    local null = require "null-ls"
    local fmt = null.builtins.formatting
    local diag = null.builtins.diagnostics
    local ca = null.builtins.code_actions

    null.setup {
        sources = {
            -- Formatters
            fmt.stylua,
            fmt.black,
            fmt.isort,
            fmt.prettierd,
            fmt.goimports,
            fmt.latexindent,
            -- fmt.prettier,
            -- fmt.stylelint,
            -- fmt.statix,

            -- Diagnostics
            diag.gitlint,
            diag.pylint,
            diag.pydocstyle,
            diag.shellcheck,
            diag.markdownlint,
            diag.hadolint,
            diag.golangci_lint,
            diag.actionlint,
            -- diag.statix,
            -- diag.stylelint,
            -- diag.selene,

            -- Code Actions
            ca.shellcheck,
            -- ca.gitsigns,
        },
        on_attach = on_attach,
    }
end


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "onsails/lspkind-nvim",
        "kosayoda/nvim-lightbulb",
        "b0o/schemastore.nvim",
        "simrat39/rust-tools.nvim",
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    keys = {
        { "<c-.>", vim.lsp.buf.code_action, desc = "LSP: Code Actions" },
        { "R",     rename,                  desc = "LSP: Rename" },
        { "gh",    vim.lsp.buf.hover,       desc = "LSP: Hover" },
    },
    config = function()
        local lsp_config = require "lspconfig"

        -- Override diagnostic signs
        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            local opts = { text = icon, texthl = hl, numhl = hl }
            vim.fn.sign_define(hl, opts)
        end

        -- Setup look of diagnostics
        vim.diagnostic.config {
            underline = true,
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            severity_sort = true,
        }

        -- Advertise client capabilities to servers
        local cmp_nvim_lsp = require "cmp_nvim_lsp"
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Override options for lsp handlers
        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = true, border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
                { focusable = false, border = "rounded" }),
        }

        -- All the servers I want to use and any custom configuration
        local servers = {
            hls = {
                settings = {
                    languageServerHaskell = {
                        formattingProvider = "stylish-haskell",
                    },
                },
            },
            clangd = {
                cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
            },
            pyright = {},
            vimls = {},
            elmls = {},
            dockerls = {},
            html = {},
            cssls = {},
            eslint = {},
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
            yamlls = {},
        }

        -- Setup all the servers with their respective settings
        for ls, settings in pairs(servers) do
            local s = vim.tbl_extend(
                "error",
                settings,
                { on_attach = on_attach, capabilities = capabilities, handlers = handlers }
            )
            lsp_config[ls].setup(s)
        end

        setup_lsp_signature()
        setup_null()
    end,
}
