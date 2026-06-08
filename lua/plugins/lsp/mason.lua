return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Server LSP usati: installati (ensure_installed) e abilitati (automatic_enable).
		-- La lista positiva di automatic_enable evita che si accendano i vecchi server
		-- ancora installati in mason (svelte/tailwind/graphql/prisma) o tool come stylua.
		local servers = {
			"lua_ls", -- Lua (per editare questa config)
			"pyright", -- Python
			"r_language_server", -- R (richiede il pacchetto R 'languageserver')
			"html", -- HTML
			"cssls", -- CSS
			"emmet_ls", -- abbreviazioni Emmet (HTML/PHP)
			"ts_ls", -- JavaScript / TypeScript
			"intelephense", -- PHP
			"sqlls", -- SQL (compatibile MySQL/MariaDB)
		}

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_enable = servers,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
				"php-cs-fixer", -- php formatter
				"sql-formatter", -- sql formatter
				"air", -- R formatter
			},
		})
	end,
}
