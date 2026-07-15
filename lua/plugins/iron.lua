return {
	"Vigemus/iron.nvim",
	ft = { "python", "r", "sh" },
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")

		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					python = {
						command = { "python3" },
						format = require("iron.fts.common").bracketed_paste_python,
					},
					r = { command = { "R" } },
					sh = { command = { "zsh" } },
				},
				repl_open_cmd = view.split.vertical.botright(0.4),
			},
			-- prefisso <leader>i = iron/REPL
			keymaps = {
				toggle_repl = "<leader>ir",
				restart_repl = "<leader>iR",
				send_line = "<leader>il",
				visual_send = "<leader>iv",
				send_paragraph = "<leader>ip",
				send_until_cursor = "<leader>iu",
				send_file = "<leader>if",
				cr = "<leader>i<cr>",
				interrupt = "<leader>ix",
				exit = "<leader>iq",
				clear = "<leader>ic",
			},
			highlight = { italic = true },
			ignore_blank_lines = true,
		})
	end,
}
