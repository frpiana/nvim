return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- 'master' è congelato; 'main' è il rewrite richiesto da Neovim 0.12
	lazy = false, -- il branch main NON supporta il lazy-loading
	build = ":TSUpdate",
	config = function()
		-- Installa i parser per le lingue che usi (idempotente; async)
		require("nvim-treesitter").install({
			"lua", "vim", "vimdoc", "query",
			"python", "r", "haskell",
			"html", "css", "javascript", "typescript", "tsx", "php", "sql",
			"json", "yaml", "toml", "markdown", "markdown_inline",
			"bash", "gitcommit", "diff",
		})

		-- Highlight (core di Neovim) + indent treesitter (sperimentale).
		-- Si attivano solo per i buffer che hanno un parser disponibile.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function()
				if pcall(vim.treesitter.start) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
