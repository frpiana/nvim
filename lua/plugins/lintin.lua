return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Lancia solo i linter il cui binario esiste davvero: se un tool di mason
		-- non è (ancora) installato, niente errore ENOENT a ogni BufEnter.
		local function lint_if_available()
			local names = lint.linters_by_ft[vim.bo.filetype] or {}
			local runnable = {}
			for _, name in ipairs(names) do
				local linter = lint.linters[name]
				local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
				if vim.fn.executable(cmd) == 1 then
					table.insert(runnable, name)
				end
			end
			if #runnable > 0 then
				lint.try_lint(runnable)
			end
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = lint_if_available,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
