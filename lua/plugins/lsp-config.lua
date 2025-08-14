return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    { "simrat39/symbols-outline.nvim" },
    { "Hoffs/omnisharp-extended-lsp.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    -- "csharp_ls",
                    -- "omnisharp",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
            local lspconfig = require("lspconfig")
            local nvlsp = require("cmp_nvim_lsp")
            lspconfig.lua_ls.setup({
                capabilities = nvlsp.default_capabilities(),
            })
            lspconfig.ts_ls.setup({
                capabilities = nvlsp.default_capabilities(),
            })

            lspconfig.omnisharp.setup({
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                enable_roslyn_analyzers = true,
                organize_imports_on_format = true,
                enable_import_completion = true,
                enable_ms_build_load_projects_on_demand = false,
                -- root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
                settings = {
                    RoslynExtensionsOptions = {
                        enableDecompilationSupport = true,
                        enableImportCompletion = true,
                        enableAnalyzersSupport = true,
                        organizeImportsOnFormat = true,
                    },
                    MsBuild = {
                        UseLegacySdkResolver = false,
                    },
                },
                handlers = {
                    ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
                    ["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
                    ["textDocument/references"] = require("omnisharp_extended").references_handler,
                    ["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
                },
                capabilities = nvlsp.default_capabilities(),
            })

            vim.diagnostic.config({
                signs = false,
            })

            vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { desc = "Get Overloads" })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
            vim.keymap.set(
                "n",
                "gu",
                "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<CR>",
                { desc = "Find References" }
            )
            vim.keymap.set(
                "n",
                "gd",
                "<cmd>lua require('omnisharp_extended').telescope_lsp_definition()<CR>",
                { desc = "Go To Definitions" }
            )
            vim.keymap.set(
                "n",
                "gi",
                "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<CR>",
                { desc = "Go To imlementations" }
            )
            vim.keymap.set(
                "n",
                "<leader>D",
                "<cmd>lua require('omnisharp_extended').lsp_type_definition()<CR>",
                { desc = "Go To Type Definitions" }
            )
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            bind = true,
            floating_window = true,
            hint_enable = true,
            handler_opts = {
                border = "rounded",
            },
            toggle_key = "<C-k>", -- toggle signature help
            max_height = 15,
            max_width = 80,
        },
    },
}
