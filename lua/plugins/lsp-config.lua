return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = { border = "rounded" }
		},
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					--                    "roslyn",
				},
			})
		end,
	},
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = "cs",
		config = function(_, opts)
			require("roslyn").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = { severity = vim.diagnostic.severity.ERROR },
				update_in_insert = true,
				severity_sort = true,
				float = {
					border = "rounded", -- "single" | "double" | "rounded" | "solid" | "shadow"
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN]  = " ",
						[vim.diagnostic.severity.INFO]  = " ",
						[vim.diagnostic.severity.HINT]  = "󰌵 ",
					},
				},
			})
			nvlsp = require("cmp_nvim_lsp")
			vim.lsp.config("lua_ls", {
				capabilities = nvlsp.default_capabilities(),
			})
			vim.lsp.config("ts_ls", {
				capabilities = nvlsp.default_capabilities(),
			})

			vim.lsp.config("roslyn", {
				on_attach = function()
				end,
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
						dotnet_enable_tests_code_lens = true,
					},
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
				},
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover" })
			vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
			vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
			vim.keymap.set("n", "gu", vim.lsp.buf.references, { desc = "Find References" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go To Definitions" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go To imlementations" })
			-- vim.keymap.set("n", "<leader>gi", function ()
			--     vim.cmd("vsplit")
			--     vim.lsp.buf.implementation()
			-- end , { desc = "Go To imlementations in vsplit" })
			vim.keymap.set("n", "<leader>di", vim.diagnostic.setqflist, { desc = "Show all diagnostics" })
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })


			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "roslyn" then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		enabled = true,
		event = "InsertEnter",
		opts = {
			bind = true,
			floating_window_above_cur_line = true,
			floating_window = true,
			hint_enable = true,
			handler_opts = {
				border = "rounded",
			},
			toggle_key = "<C-k>", -- toggle signature help
			max_height = 15,
			max_width = 80,
			always_trigger = false,
			transparency = nil,
			shadow_blend = 36, -- if you using shadow as border use this set the opacity
			shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
		},
	},
}
