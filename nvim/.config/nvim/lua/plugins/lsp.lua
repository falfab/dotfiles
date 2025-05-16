return {
	{
		{
			"williamboman/mason.nvim",
			lazy = false,
			opts = {},
		},

		-- Allow tab autocompletion
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},

		-- Autocompletion
		{
			"saghen/blink.cmp",
			-- optional: provides snippets for the snippet source
			dependencies = {
				"giuxtaposition/blink-cmp-copilot",
				"rafamadriz/friendly-snippets",
				"giuxtaposition/blink-cmp-copilot",
			},
			-- use a release tag to download pre-built binaries
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = "super-tab" },

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
					-- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
					kind_icons = {
						Copilot = "",
						Text = "󰉿",
						Method = "󰊕",
						Function = "󰊕",
						Constructor = "󰒓",

						Field = "󰜢",
						Variable = "󰆦",
						Property = "󰖷",

						Class = "󱡠",
						Interface = "󱡠",
						Struct = "󱡠",
						Module = "󰅩",

						Unit = "󰪚",
						Value = "󰦨",
						Enum = "󰦨",
						EnumMember = "󰦨",

						Keyword = "󰻾",
						Constant = "󰏿",

						Snippet = "󱄽",
						Color = "󰏘",
						File = "󰈔",
						Reference = "󰬲",
						Folder = "󰉋",
						Event = "󱐋",
						Operator = "󰪚",
						TypeParameter = "󰬛",
					},
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = true } },

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					providers = {
						copilot = {
							name = "copilot",
							module = "blink-cmp-copilot",
							score_offset = 100,
							async = true,
							transform_items = function(_, items)
								local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
								local kind_idx = #CompletionItemKind + 1
								CompletionItemKind[kind_idx] = "Copilot"
								for _, item in ipairs(items) do
									item.kind = kind_idx
								end
								return items
							end,
						},
					},
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"nvimtools/none-ls.nvim",
			config = function()
				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.black,
					},
					-- Automatic format
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({
										bufnr = bufnr,
										filter = function(formatter)
											return formatter.name == "null-ls"
										end,
										asnyc = false,
									})
								end,
							})
						end
					end,
				})
			end,
		},

		-- LSP
		{
			"neovim/nvim-lspconfig",
			cmd = { "LspInfo", "LspInstall", "LspStart" },
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
			},
			init = function()
				-- Reserve a space in the gutter
				-- This will avoid an annoying layout shift in the screen
				vim.opt.signcolumn = "yes"
			end,
			config = function()
				local lsp_defaults = require("lspconfig").util.default_config

				-- LspAttach is where you enable features that only work
				-- if there is a language server active in the file
				vim.api.nvim_create_autocmd("LspAttach", {
					desc = "LSP actions",
					callback = function(event)
						local opts = { buffer = event.buf }

						vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
						vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
						vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
						vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
						vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
						vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
						vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
						vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
						vim.keymap.set("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
						vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)

						local id = vim.tbl_get(event, "data", "client_id")
						local client = id and vim.lsp.get_client_by_id(id)
						if client == nil then
							return
						end
					end,
				})

				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd" },
					handlers = {
						-- this first function is the "default handler"
						-- it applies to every language server without a "custom handler"
						function(server_name)
							-- on_attach is used to connect the lsp-format plugin
							require("lspconfig")[server_name].setup({})
						end,
					},
				})
			end,
		},
	},
}
