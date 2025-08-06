return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"csharp_ls",
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

			lspconfig.csharp_ls = {
				default_config = {
					cmd = { "csharp-ls" },
					filetypes = { "cs" },
					root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
					init_options = {
						RoslynExtensionsOptions = {
							enableDecompilationSupport = true,
							enableAnalyzersSupport = true,
						},
						FormattingOptions = {
							enable = true, -- (bool) Enable formatting support (default: true)
							tabSize = 4, -- (int) Tab size for formatting
							insertSpaces = false, -- (bool) Use spaces instead of tabs
							newLine = "\n", -- (string) New line character(s)
						},
					},
				},
			}
			-- lspconfig.csharp_ls.setup({})
			--
			-- local pid = vim.fn.getpid()
			-- lspconfig.omnisharp.setup({
			--     enable_editorconfig_support = true,
			--     enable_ms_build_load_projects_on_demand = false,
			--     enable_roslyn_analyzers = true,
			--     organize_imports_on_format = true,
			--     enable_import_completion = true,
			--     filetypes = { "cs", "vb" },
			--     capabilities = nvlsp.default_capabilities(),
			--     cmd = {
			--         "C:\\Users\\rchubak\\.tools\\omnisharp-win-x64\\OmniSharp.exe",
			--         "--languageserver",
			--         "--hostPID",
			--         tostring(pid),
			--     },
			--     on_new_config = function(config, _)
			--         config.cmd_env = {
			--             MSBUILD_EXE_PATH =
			--             "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe",
			--             DOTNET_ROOT = "C:\\Program Files\\dotnet\\",
			--             -- DOTNET_MSBUILD_SDK_RESOLVER_SDKS_DIR = "C:\\Program Files\\dotnet\\sdk",
			--             --C:\Program Files\dotnet\sdk\9.0.303\Sdks\Microsoft.NET.Sdk
			--             --C:\Program Files\dotnet\sdk\9.0.302\Sdks\Microsoft.NET.Sdk
			--             --C:\Program Files\dotnet\sdk\8.0.412\Sdks\Microsoft.NET.Sdk
			--             --C:\Program Files\dotnet\sdk\6.0.428\Sdks\Microsoft.NET.Sdk
			--             DOTNET_MSBUILD_SDK_RESOLVER_SDKS_DIR = "C:\\Program Files\\dotnet\\sdk\\9.0.302\\Sdks\\",
			--             MSBuildSDKsPath = "C:\\Program Files\\dotnet\\sdk\\9.0.303\\Sdks\\",
			--         }
			--     end,
			--     handlers = {
			--         ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
			--     },
			-- })

			vim.diagnostic.config({
				signs = false,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.api.nvim_set_keymap(
				"n",
				"gu",
				"<cmd>lua vim.lsp.buf.references()<CR>",
				{ noremap = true, silent = true }
			)

			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
			-- vim.keymap.set("n", "gu", "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<CR>", opts)
			-- vim.keymap.set("n", "gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definition()<CR>", opts)
			-- vim.keymap.set("n", "gi", "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<CR>", opts)
			-- vim.keymap.set("n", "<leader>D", "<cmd>lua require('omnisharp_extended').lsp_type_definition()<CR>", opts)

			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
		end,
	},
	-- {
	-- 	"Hoffs/omnisharp-extended-lsp.nvim",
	-- },
}
