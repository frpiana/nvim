-- Sostituisce dressing.nvim (archiviato): UI migliori per vim.ui.input (rename LSP)
-- e vim.ui.select (code action), senza toccare Telescope come picker principale.
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = { enabled = true },
		picker = { enabled = true, ui_select = true },
	},
}
